//
//  CMPFileViewController.h
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CMPFileSystem.h"

@interface CMPFileViewController : UITableViewController
{
    NSObject<CMPFileSystem>* fs;
    NSArray* names;
}

@end
