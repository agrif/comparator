//
//  CMPDismissSegue.m
//  Comparator
//
//  Created by Aaron Griffith on 4/27/15.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

#import "CMPDismissSegue.h"

@implementation CMPDismissSegue

- (void) perform
{
    [self.sourceViewController dismissViewControllerAnimated: YES completion: nil];
}

@end
