//
//  CMPDocumentViewController.m
//  Comparator
//
//  Created by Aaron Griffith on 4/25/15.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

#import "MBProgressHUD.h"
#import "CMPDocumentViewController.h"
#import "CMPInfoTableView.h"
#import "CMPLocalFileSystem.h"

@implementation CMPDocumentViewController

@synthesize webView;

- (void) viewDidLoad
{
    if (file)
        [self setFile: file];
}

- (void) dealloc
{
    file = nil;
}

- (void)prepareForSegue: (UIStoryboardSegue*) segue sender: (id) sender
{
    if ([segue.identifier isEqualToString: @"Open"])
    {
        UINavigationController* nav = [segue destinationViewController];
        CMPFileViewController* fvc = [nav.viewControllers objectAtIndex: 0];
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex: 0];
        
        NSLog(@"documents directory at %@\n", documentsDirectory);
        fvc.delegate = self;
        fvc.fileSystem = [CMPLocalFileSystem localFileSystemAtPath: documentsDirectory];
        fvc.path = @[];
    } else if ([segue.identifier isEqualToString: @"About"]) {
        UINavigationController* nav = [segue destinationViewController];
        UITableViewController* cont = [nav.viewControllers objectAtIndex: 0];
        CMPInfoTableView* info = (CMPInfoTableView*)(cont.tableView);
        [info loadContentsOfURL: [[NSBundle mainBundle] URLForResource: @"About" withExtension: @"xml"]];
    }
}

- (void) fileViewController: (CMPFileViewController*) controller didSelectFile: (CMPFile*) newFile
{
    NSLog(@"selected file: %@\n", newFile.path);
    self.file = newFile;
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) setFile: (CMPFile*) newFile
{
    MBProgressHUD* hud = [MBProgressHUD HUDForView: self.view];
    if (!hud)
        hud = [[MBProgressHUD alloc] initWithView: self.view];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"Loading...";
    hud.detailsLabelText = newFile.name;
    hud.dimBackground = YES;
    hud.graceTime = 0.2f;
    hud.minShowTime = 0.5f;

    hud.taskInProgress = YES;
    hud.progress = 0.0f;
    [hud show: YES];
    
    file = newFile;
    [file readDataWithProgress: ^(NSUInteger x, NSUInteger max)
    {
        // FIXME cancellation if file != newFile
        hud.progress = (float)(x) / max;
    } completion: ^(NSData* dat, NSError* err)
    {
        if (dat)
        {
            // make sure we still want this file
            if (file == newFile)
            {
                NSString* mime = nil;
                if ([file.name hasSuffix: @".pdf"])
                    mime = @"application/pdf"; // FIXME better mime types
                [webView loadData: dat MIMEType: mime textEncodingName: nil baseURL: nil];
                hud.taskInProgress = NO;
                [hud hide: YES];
            }
        } else {
            NSLog(@"error opening file: %@\n", err);
        }
    }];
}

@end
