//
//  SDHoleFilterTableViewController.m
//  shudong
//
//  Created by Eric Tao on 5/4/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDHoleFilterTableViewController.h"
#import "SDHole.h"
#import "SDUtils.h"
@interface SDHoleFilterTableViewController ()
@property NSArray *collegeArr;
@property NSArray *technicalArr;
@property NSArray *middleArr;
@property NSArray *primaryArr;
@property NSArray *otherArr;


@end

@implementation SDHoleFilterTableViewController
@synthesize holesDict;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initializeSchoolArr {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    
    
    
    _collegeArr = [NSArray arrayWithArray:holesDict[@0]];
    _technicalArr = [NSArray arrayWithArray:holesDict[@1]];
    _middleArr = [NSArray arrayWithArray:holesDict[@2]];
    _primaryArr = [NSArray arrayWithArray:holesDict[@3]];
    _otherArr = [NSArray arrayWithArray:holesDict[@4]];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return 5;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSArray *theArr = [NSArray arrayWithArray:holesDict[[NSNumber numberWithInt:section]]];
    //return theArr.count;
    return [[SDUtils sharedInstance] myHoles].count;
}
- (IBAction)confirmSelecting:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    //NSArray *targetArr = holesDict[[NSNumber numberWithInt:indexPath.section]];
    //SDHole *targetHole = targetArr[indexPath.row];
    //cell.textLabel.text = targetHole.name;
    cell.textLabel.text = ((SDHole*)[[[SDUtils sharedInstance] myHoles] objectAtIndex:indexPath.row]).name;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
