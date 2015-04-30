//
//  CMPMetaFileSystem.m
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

#import "CMPMetaFileSystem.h"
#import "NSArray+HasPrefix.h"

@implementation CMPMetaFileSystem

+ (instancetype) metaFileSystem
{
    return [[CMPMetaFileSystem alloc] init];
}

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        mounts = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc
{
    if (mounts)
        mounts = nil;
}

- (void) mountFileSystem: (NSObject<CMPFileSystem>*) fileSystem atPath: (NSArray*) path
{
    [mounts setObject: fileSystem forKey: path];
}

- (void) unmountPath: (NSArray*) path
{
    [mounts removeObjectForKey: path];
}

- (void) unmountFileSystem: (NSObject<CMPFileSystem>*) fileSystem
{
    NSSet* paths = [mounts keysOfEntriesPassingTest: ^(id key, id object, BOOL* stop)
                    {
                        return (BOOL)(object == fileSystem);
                    }];
    for (NSArray* path in paths)
    {
        [self unmountPath: path];
    }
}

- (void) performOnMountedPath: (NSArray*) path action: (CMPPerformBlock) action
{
    NSArray* mountPath = nil;
    for (NSArray* testPath in mounts)
    {
        if ([path hasPrefix: testPath])
        {
            if (mountPath == nil || [mountPath count] < [testPath count])
            {
                mountPath = testPath;
            }
        }
    }
    
    if (mountPath)
    {
        NSArray* subPath = [path objectsAtIndexes: [NSIndexSet indexSetWithIndexesInRange: NSMakeRange([mountPath count], [path count] - [mountPath count])]];
        action([mounts objectForKey: mountPath], subPath, nil);
    } else {
        action(nil, nil, [NSError errorWithDomain: CMPFileSystemErrorDomain code: CMPFileSystemErrorNotMounted userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat: @"Nothing mounted at %@.", path]}]);
    }
}

- (void) listContentsAtPath: (NSArray*) path withCompletion: (CMPListBlock) completion
{
    [self performOnMountedPath: path action: ^(NSObject<CMPFileSystem>* fs, NSArray* subpath, NSError* error)
     {
         if (error)
             completion(nil, error);
         else
             [fs listContentsAtPath: subpath withCompletion: completion];
     }];
}

- (void) readFileAtPath: (NSArray*) path toStream: (NSOutputStream*) output withProgress: (CMPProgressBlock) progress completion: (CMPErrorBlock) completion
{
    [self performOnMountedPath: path action: ^(NSObject<CMPFileSystem>* fs, NSArray* subpath, NSError* error)
    {
        if (error)
            completion(error);
        else
            [fs readFileAtPath: subpath toStream: output withProgress: progress completion: completion];
    }];
}

@end
