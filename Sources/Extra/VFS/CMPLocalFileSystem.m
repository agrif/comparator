//
//  CMPLocalFileSystem.m
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. All rights reserved.
//

#import "CMPLocalFileSystem.h"
#import "CMPStreamCopy.h"

@implementation CMPLocalFileSystem

+ (instancetype) localFileSystemAtPath: (NSString*) path
{
    return [[CMPLocalFileSystem alloc] initAtPath: path];
}

+ (instancetype) localFileSystemWithFileManager: (NSFileManager*) fileManager atPath: (NSString*) path
{
    return [[CMPLocalFileSystem alloc] initWithFileManager: fileManager atPath: path];
}

- (instancetype) initAtPath: (NSString*) path
{
    return [self initWithFileManager: [NSFileManager defaultManager] atPath: path];
}

- (instancetype) initWithFileManager: (NSFileManager*) fileManager atPath: (NSString*) path
{
    self = [super init];
    if (self)
    {
        fm = fileManager;
        root = path;
    }
    return self;
}

- (void) dealloc
{
    if (fm)
        fm = nil;
    if (root)
        root = nil;
}

- (NSString*) actualPathFromPath: (NSArray*) path
{
    NSMutableArray* fullPathComponents = [path mutableCopy];
    [fullPathComponents insertObject: root atIndex: 0];
    return [NSString pathWithComponents: fullPathComponents];
}

- (CMPFile*) fileForPath: (NSArray*) path
{
    BOOL isDirectory = NO;
    BOOL exists = [fm fileExistsAtPath: [self actualPathFromPath: path] isDirectory: &isDirectory];
    if (!exists)
        return nil;
    return [CMPFile fileForFileSystem: self path: path type: isDirectory ? CMPFileTypeFolder : CMPFileTypeNormal];
}

- (void) listContentsAtPath: (NSArray*) path withCompletion: (CMPListBlock) completion
{
    NSError* err = nil;
    NSArray* list = [fm contentsOfDirectoryAtPath: [self actualPathFromPath: path] error: &err];
    
    if (err)
    {
        completion(nil, err);
        return;
    }
    
    NSMutableArray* items = [[NSMutableArray alloc] initWithCapacity: [list count]];
    for (NSString* leaf in list)
    {
        NSMutableArray* leafpath = [path mutableCopy];
        [leafpath addObject: leaf];
        CMPFile* file = [self fileForPath: leafpath];
        
        if (file)
            [items addObject: file];
    }
    
    completion(items, err);
}

- (void) readFileAtPath: (NSArray*) path toStream: (NSOutputStream*) output withProgress: (CMPProgressBlock) progress completion: (CMPErrorBlock) completion
{
    NSLog(@"reading file at %@\n", path);
    NSString* actualPath = [self actualPathFromPath: path];
    NSError* err = nil;
    NSDictionary* attr = [fm attributesOfItemAtPath: actualPath error: &err];
    
    if (err)
    {
        completion(err);
        return;
    }
    
    NSNumber* totalo = [attr objectForKey: NSFileSize];
    NSUInteger total = [totalo unsignedIntegerValue];

    NSInputStream* input = [NSInputStream inputStreamWithFileAtPath: actualPath];
    if (!input)
    {
        NSError* err = [NSError errorWithDomain: CMPFileSystemErrorDomain code: CMPFileSystemErrorDoesNotExist userInfo: @{NSLocalizedDescriptionKey : [NSString stringWithFormat: @"path does not exist: %@", path]}];
        completion(err);
        return;
    }
    
    CMPStreamCopy* cp = [CMPStreamCopy streamCopyFrom: input to: output withProgress: ^(NSUInteger x) { progress(x, total); } completion: ^(NSError* err) { completion(err); [input close]; }];
}

@end
