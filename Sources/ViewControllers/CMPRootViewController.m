//
//  CMPRootViewController.m
//  Comparator
//
//  Created by Aaron Griffith on 4/24/15.
//  Copyright (c) 2015 Aaron Griffith. All rights reserved.
//

#import "CMPRootViewController.h"

@implementation CMPRootViewController

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	UIStoryboard* sb = [UIStoryboard storyboardWithName: @"Document" bundle: nil];
    self.primaryViewController = [sb instantiateInitialViewController];
    self.secondaryViewController = [sb instantiateInitialViewController];
}

@end
