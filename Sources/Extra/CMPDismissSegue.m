//
//  CMPDismissSegue.m
//  Comparator
//
//  Created by Aaron Griffith on 4/27/15.
//  Copyright (c) 2015 Aaron Griffith. All rights reserved.
//

#import "CMPDismissSegue.h"

@implementation CMPDismissSegue

- (void) perform
{
    [self.sourceViewController dismissViewControllerAnimated: YES completion: nil];
}

@end
