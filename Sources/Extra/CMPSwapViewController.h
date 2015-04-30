//
//  CMPSwapViewController.h
//  Comparator
//
//  Created by Aaron Griffith on 4/27/15.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

#import <UIKit/UIKit.h>

@interface CMPSwapViewController : UIViewController
{
	UIViewController* _primary;
	UIViewController* _secondary;
}

@property (nonatomic, retain) IBOutlet UIViewController* primaryViewController;
@property (nonatomic, retain) IBOutlet UIViewController* secondaryViewController;
@property (nonatomic, readonly, getter=isShowingSecondary) BOOL showingSecondary;

@end
