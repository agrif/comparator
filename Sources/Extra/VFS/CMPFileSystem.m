//
//  CMPFileSystem.m
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. All rights reserved.
//

#import "CMPFileSystem.h"
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
        mounts = [[NSDictionary alloc] init];
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

- (void) performOnMountedPath: (NSArray*) path action: (PerformBlock) action
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

- (void) listContentsAtPath: (NSArray*) path withCompletion: (ListBlock) completion
{
    [self performOnMountedPath: path action: ^(NSObject<CMPFileSystem>* fs, NSArray* subpath, NSError* error)
    {
        if (error)
            completion(nil, error);
        else
            [fs listContentsAtPath: subpath withCompletion: completion];
    }];
}

@end
