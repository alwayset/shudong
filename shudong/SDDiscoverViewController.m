//
//  SDDiscoverViewController.m
//  shudong
//
//  Created by admin on 14-5-8.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "SDDiscoverViewController.h"
#import "SDFriendCell.h"
@interface SDDiscoverViewController ()

@end

@implementation SDDiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadFollow];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.follows.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDFriendCell* cell = [tableView dequeueReusableCellWithIdentifier:@"friend"];
    AVUser* current = [self.follows objectAtIndex:indexPath.row];
    cell.displayName.text =current[@"username"];
    return cell;
}
- (void)loadFollow {
    AVUser* currentUser = [AVUser currentUser];
    AVQuery* query = [currentUser followeeQuery];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.follows = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        } else {
            
        }
        
    }];
}
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
