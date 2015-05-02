//
//  CMPStreamCopy.m
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

#import "CMPStreamCopy.h"

#define BUFFER_SIZE (1024 * 128)

@implementation CMPStreamCopy

+ (instancetype) streamCopyFrom: (NSInputStream*) input to: (NSOutputStream*) output withProgress: (CMPSimpleProgressBlock) progress completion: (CMPErrorBlock) completion
{
    return [[CMPStreamCopy alloc] initFrom: input to: output withProgress: progress completion: completion];
}

- (instancetype) initFrom: (NSInputStream*) input to: (NSOutputStream*) output withProgress: (CMPSimpleProgressBlock) progress completion: (CMPErrorBlock) completion
{
    self = [super init];
    if (self)
    {
        buffer = malloc(BUFFER_SIZE);
        if (!buffer)
            return nil;
        
        i = input;
        o = output;
        doProgress = progress;
        doComplete = completion;
        written = 0;
        bufLen = 0;
        bufOffs = 0;
        
        arcHack = self;
        
        i.delegate = self;
        o.delegate = self;
        [i scheduleInRunLoop: [NSRunLoop currentRunLoop] forMode: NSRunLoopCommonModes];
        [o scheduleInRunLoop: [NSRunLoop currentRunLoop] forMode: NSRunLoopCommonModes];
        [i open];
        [o open];
    }
    return self;
}

- (void) dealloc
{
    i = nil;
    o = nil;
    doProgress = NULL;
    doComplete = NULL;
    arcHack = nil;
    if (buffer)
    {
        free(buffer);
        buffer = NULL;
    }
}

- (void) stream: (NSStream*) aStream handleEvent: (NSStreamEvent) eventCode
{
    if (eventCode == NSStreamEventErrorOccurred)
    {
        doComplete(aStream.streamError);
        [i removeFromRunLoop: [NSRunLoop mainRunLoop] forMode: NSRunLoopCommonModes];
        [o removeFromRunLoop: [NSRunLoop mainRunLoop] forMode: NSRunLoopCommonModes];
        return;
    }
    
    if (i.hasBytesAvailable && bufLen == 0)
        bufLen = [i read: buffer maxLength: BUFFER_SIZE];
    
    if (o.hasSpaceAvailable && bufLen > 0)
    {
        NSInteger l = [o write: (buffer + bufOffs) maxLength: bufLen];
        bufLen -= l;
        bufOffs += l;
    }
    
    if (bufOffs > 0 && bufLen == 0)
    {
        written += bufOffs;
        bufOffs = 0;
        BOOL shouldContinue = doProgress(written);
        if (!shouldContinue)
        {
            doComplete([NSError errorWithDomain: CMPFileSystemErrorDomain code: CMPFileSystemErrorCancelled userInfo: @{NSLocalizedDescriptionKey : @"operation cancelled"}]);
            [i removeFromRunLoop: [NSRunLoop mainRunLoop] forMode: NSRunLoopCommonModes];
            [o removeFromRunLoop: [NSRunLoop mainRunLoop] forMode: NSRunLoopCommonModes];
            return;
        }
    }
    
    if (bufLen == 0 && i.streamStatus == NSStreamStatusAtEnd)
    {
        doComplete(nil);
        
        i = nil;
        o = nil;
        arcHack = nil;
    }
}

@end
