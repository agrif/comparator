//
//  CMPFileSystem.h
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

#define CMPFileSystemErrorDomain @"net.rakeri.CMPFileSystem.ErrorDomain"
typedef enum
{
    CMPFileSystemErrorNotMounted,
    CMPFileSystemErrorDoesNotExist,
    CMPFileSystemErrorCancelled,
} CMPFileSystemErrorCode;

typedef enum
{
    CMPFileTypeNormal,
    CMPFileTypeFolder,
} CMPFileType;

typedef void (^CMPListBlock)(NSArray*, NSError*);

typedef void (^CMPDataBlock)(NSData*, NSError*);

// return YES to continue, NO to cancel
// canceled ops get error in completion call
typedef BOOL (^CMPProgressBlock)(NSUInteger, NSUInteger);

typedef void (^CMPErrorBlock)(NSError*);

@protocol CMPFileSystem

- (void) listContentsAtPath: (NSArray*) path withCompletion: (CMPListBlock) completion;
// output is left open for completion() to close, or do whatever with
- (void) readFileAtPath: (NSArray*) path toStream: (NSOutputStream*) output withProgress: (CMPProgressBlock) progress completion: (CMPErrorBlock) completion;

@end

@interface CMPFile : NSObject
{
    NSObject<CMPFileSystem>* fileSystem;
    NSArray* path;
    CMPFileType type;
}

+ (instancetype) fileForFileSystem: (NSObject<CMPFileSystem>*) fileSystem path: (NSArray*) path type: (CMPFileType) type;
- (instancetype) initForFileSystem: (NSObject<CMPFileSystem>*) fileSystem path: (NSArray*) path type: (CMPFileType) type;

@property (nonatomic, readonly) NSObject<CMPFileSystem>* fileSystem;
@property (nonatomic, readonly) NSArray* path;
@property (nonatomic, readonly) CMPFileType type;

- (void) readToStream: (NSOutputStream*) output withProgress: (CMPProgressBlock) progress completion: (CMPErrorBlock) completion;
- (void) readDataWithProgress: (CMPProgressBlock) progress completion: (CMPDataBlock) completion;

@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) BOOL isFile;
@property (nonatomic, readonly) BOOL isFolder;

@end
