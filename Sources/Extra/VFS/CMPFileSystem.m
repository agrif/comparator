//
//  CMPFileSystem.m
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. All rights reserved.
//

#import "CMPFileSystem.h"

@implementation CMPFile

@synthesize fileSystem, path, type;

+ (instancetype) fileForFileSystem: (NSObject<CMPFileSystem>*) fileSystem path: (NSArray*) path type: (CMPFileType) type
{
    return [[CMPFile alloc] initForFileSystem: fileSystem path: path type: type];
}

- (instancetype) initForFileSystem: (NSObject<CMPFileSystem>*) fs path: (NSArray*) p type: (CMPFileType) t
{
    self = [super init];
    if (self)
    {
        fileSystem = fs;
        path = p;
        type = t;
    }
    return self;
}

- (void) dealloc
{
    fileSystem = nil;
    path = nil;
}

- (void) readToStream: (NSOutputStream*) output withProgress: (CMPProgressBlock) progress completion: (CMPErrorBlock) completion
{
    [fileSystem readFileAtPath: path toStream: output withProgress: progress completion: completion];
}

- (void) readDataWithProgress: (CMPProgressBlock) progress completion: (CMPDataBlock) completion
{
    NSOutputStream* output = [NSOutputStream outputStreamToMemory];
    [self readToStream: output withProgress: progress completion: ^(NSError* err)
    {
        if (err)
        {
            completion(nil, err);
            return;
        }
        
        completion([output propertyForKey: NSStreamDataWrittenToMemoryStreamKey], nil);
        [output close];
    }];
}

- (NSString*) name
{
    if ([path count])
        return [path objectAtIndex: [path count] - 1];
    return @"/";
}

- (BOOL) isFile
{
    return (BOOL)(type == CMPFileTypeNormal);
}

- (BOOL) isFolder
{
    return (BOOL)(type == CMPFileTypeFolder);
}

@end
