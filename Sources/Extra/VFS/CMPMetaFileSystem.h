//
//  CMPMetaFileSystem.h
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

#import <Foundation/Foundation.h>
#import "CMPFileSystem.h"

typedef void (^CMPPerformBlock)(NSObject<CMPFileSystem>*, NSArray*, NSError*);

@interface CMPMetaFileSystem : NSObject <CMPFileSystem>
{
    NSMutableDictionary* mounts;
}

+ (instancetype) metaFileSystem;
- (instancetype) init;

- (void) mountFileSystem: (NSObject<CMPFileSystem>*) fileSystem atPath: (NSArray*) path;
- (void) unmountPath: (NSArray*) path;
- (void) unmountFileSystem: (NSObject<CMPFileSystem>*) fileSystem;
- (void) performOnMountedPath: (NSArray*) path action: (CMPPerformBlock) action;

@end
