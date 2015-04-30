//
//  CMPFileViewController.h
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

#import <UIKit/UIKit.h>
#include "CMPFileSystem.h"

@class CMPFileViewController;

@protocol CMPFileViewControllerDelegate

- (void) fileViewController: (CMPFileViewController*) controller didSelectFile: (CMPFile*) file;

@end

@interface CMPFileViewController : UITableViewController
{
    __weak id<CMPFileViewControllerDelegate> delegate;
    NSObject<CMPFileSystem>* fileSystem;
    NSArray* path;
    
    NSArray* files;
}

@property (nonatomic, weak) id<CMPFileViewControllerDelegate> delegate;
@property (nonatomic, retain) NSObject<CMPFileSystem>* fileSystem;
@property (nonatomic, retain) NSArray* path;

@end
