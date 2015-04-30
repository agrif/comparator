//
//  CMPDocumentViewController.h
//  Comparator
//
//  Created by Aaron Griffith on 4/25/15.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

#import <UIKit/UIKit.h>
#import "CMPFileViewController.h"

@interface CMPDocumentViewController : UIViewController <CMPFileViewControllerDelegate>
{
    UIWebView* webView;
}

@property (nonatomic, retain) IBOutlet UIWebView* webView;

@end
