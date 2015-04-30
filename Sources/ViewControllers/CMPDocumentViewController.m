//
//  CMPDocumentViewController.m
//  Comparator
//
//  Created by Aaron Griffith on 4/25/15.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

#import "CMPDocumentViewController.h"
#import "CMPLocalFileSystem.h"

@implementation CMPDocumentViewController

@synthesize webView;

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
    }
}

- (void) fileViewController: (CMPFileViewController*) controller didSelectFile: (CMPFile*) file
{
    NSLog(@"selected file: %@\n", file.path);
    [file readDataWithProgress: ^(NSUInteger x, NSUInteger max) {} completion: ^(NSData* dat, NSError* err)
    {
        if (dat)
        {
            NSString* mime = nil;
            if ([file.name hasSuffix: @".pdf"])
                mime = @"application/pdf";
            [webView loadData: dat MIMEType: mime textEncodingName: nil baseURL: nil];
            [self dismissViewControllerAnimated: YES completion: nil];
        } else {
            NSLog(@"error opening file: %@\n", err);
        }
    }];
}

@end
