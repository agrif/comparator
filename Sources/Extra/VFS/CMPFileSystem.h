//
//  CMPFileSystem.h
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CMPFileSystemErrorDomain @"net.rakeri.CMPFileSystem.ErrorDomain"
enum CMPFileSystemErrorCode
{
    CMPFileSystemErrorNotMounted,
};

typedef void (^ListBlock)(NSArray*, NSError*);

@protocol CMPFileSystem

- (void) listContentsAtPath: (NSArray*) path withCompletion: (ListBlock) completion;

@end

typedef void (^PerformBlock)(NSObject<CMPFileSystem>*, NSArray*, NSError*);

@interface CMPMetaFileSystem : NSObject <CMPFileSystem>
{
    NSMutableDictionary* mounts;
}

+ (instancetype) metaFileSystem;
- (instancetype) init;

- (void) mountFileSystem: (NSObject<CMPFileSystem>*) fileSystem atPath: (NSArray*) path;
- (void) unmountPath: (NSArray*) path;
- (void) unmountFileSystem: (NSObject<CMPFileSystem>*) fileSystem;
- (void) performOnMountedPath: (NSArray*) path action: (PerformBlock) action;

@end
