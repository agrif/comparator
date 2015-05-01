//
//  CMPStreamCopy.h
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

#import "CMPFileSystem.h"

typedef void (^CMPSimpleProgressBlock)(NSUInteger);

@interface CMPStreamCopy : NSObject <NSStreamDelegate>
{
    NSInputStream* i;
    NSOutputStream* o;
    CMPSimpleProgressBlock doProgress;
    CMPErrorBlock doComplete;
    uint8_t* buffer;
    
    // keep a reference to itself until the job is done
    CMPStreamCopy *arcHack;
    
    NSUInteger written, bufLen, bufOffs;
}

+ (instancetype) streamCopyFrom: (NSInputStream*) input to: (NSOutputStream*) output withProgress: (CMPSimpleProgressBlock) progress completion: (CMPErrorBlock) completion;
- (instancetype) initFrom: (NSInputStream*) input to: (NSOutputStream*) output withProgress: (CMPSimpleProgressBlock) progress completion: (CMPErrorBlock) completion;

@end
