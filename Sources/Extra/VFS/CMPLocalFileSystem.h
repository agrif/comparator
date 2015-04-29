//
//  CMPLocalFileSystem.h
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPFileSystem.h"

@interface CMPLocalFileSystem : NSObject <CMPFileSystem>
{
    NSFileManager* fm;
    NSString* root;
}

+ (instancetype) localFileSystemAtPath: (NSString*) path;
+ (instancetype) localFileSystemWithFileManager: (NSFileManager*) fileManager atPath: (NSString*) path;
- (instancetype) initAtPath: (NSString*) path;
- (instancetype) initWithFileManager: (NSFileManager*) fileManager atPath: (NSString*) path;

@end
