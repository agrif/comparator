//
//  CMPFileViewController.m
//  Comparator
//
//  Created by Aaron Griffith on 4/29/15.
//  Copyright (c) 2015 Aaron Griffith. All rights reserved.
//

#import "CMPFileViewController.h"
#import "CMPLocalFileSystem.h"

@implementation CMPFileViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex: 0];
    
    NSLog(@"documents directory at %@\n", documentsDirectory);
    fs = [CMPLocalFileSystem localFileSystemAtPath: documentsDirectory];
    names = nil;
}

- (void) viewDidUnload
{
    fs = nil;
    names = nil;
}

- (void) viewWillAppear: (BOOL) animated
{
    [fs listContentsAtPath: @[] withCompletion: ^(NSArray* contents, NSError* err)
    {
        if (contents)
        {
            NSLog(@"found contents %@\n", contents);
            names = contents;
            [self.tableView reloadSections: [NSIndexSet indexSetWithIndex: 0] withRowAnimation: UITableViewRowAnimationAutomatic];
        }
    }];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView: (UITableView*) tableView
{
    // Return the number of sections.
    if (names)
        return 1;
    return 0;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection: (NSInteger) section
{
    // Return the number of rows in the section.
    if (names)
        return [names count];
    return 0;
}

- (UITableViewCell*) tableView: (UITableView*) tableView cellForRowAtIndexPath: (NSIndexPath*) indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CMPFileViewEntry" forIndexPath: indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [names objectAtIndex: [indexPath indexAtPosition: 1]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
