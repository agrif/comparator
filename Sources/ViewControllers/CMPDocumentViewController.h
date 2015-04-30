//
//  CMPDocumentViewController.h
//  Comparator
//
//  Created by Aaron Griffith on 4/25/15.
//  Copyright (c) 2015 Aaron Griffith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPFileViewController.h"

@interface CMPDocumentViewController : UIViewController <CMPFileViewControllerDelegate>
{
    UIWebView* webView;
}

@property (nonatomic, retain) IBOutlet UIWebView* webView;

@end
