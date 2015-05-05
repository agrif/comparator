//
//  CMPRootViewController.m
//  Comparator
//
//  Created by Aaron Griffith on 4/24/15.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

#import "CMPRootViewController.h"
#import "CMPInfoTableView.h"

@implementation CMPRootViewController

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	UIStoryboard* sb = [UIStoryboard storyboardWithName: @"Document" bundle: nil];
    self.primaryViewController = [sb instantiateInitialViewController];
    self.secondaryViewController = [sb instantiateInitialViewController];
}

- (void)prepareForSegue: (UIStoryboardSegue*) segue sender: (id) sender
{
    if ([segue.identifier isEqualToString: @"About"]) {
        UINavigationController* nav = [segue destinationViewController];
        UITableViewController* cont = [nav.viewControllers objectAtIndex: 0];
        CMPInfoTableView* info = (CMPInfoTableView*)(cont.tableView);
        [info loadContentsOfURL: [[NSBundle mainBundle] URLForResource: @"About" withExtension: @"xml"]];
    }
}

@end
