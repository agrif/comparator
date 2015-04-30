//
//  NSArray+HasPrefix.m
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

#import "NSArray+HasPrefix.h"

@implementation NSArray (HasPrefix)

- (BOOL) hasPrefix: (NSArray*) anArray
{
    NSUInteger ours = [self count];
    NSUInteger theirs = [anArray count];
    if (theirs > ours)
        return NO;
    return [anArray isEqualToArray: [self objectsAtIndexes: [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(0, theirs)]]];
}

@end
