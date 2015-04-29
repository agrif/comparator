//
//  CMPLocalFileSystem.m
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. All rights reserved.
//

#import "CMPLocalFileSystem.h"

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

- (void) listContentsAtPath: (NSArray*) path withCompletion: (ListBlock) completion
{
    NSError* err = nil;
    NSMutableArray* fullPathComponents = [path mutableCopy];
    [fullPathComponents insertObject: root atIndex:0];
    
    NSString* fullPath = [NSString pathWithComponents: fullPathComponents];
    NSArray* list = [fm contentsOfDirectoryAtPath: fullPath error: &err];
    
    if (err)
        completion(nil, err);
    else
        completion(list, nil);
}

@end
