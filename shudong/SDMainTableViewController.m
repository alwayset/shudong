//
//  SDMainTableViewController.m
//  shudong
//
//  Created by Eric Tao on 4/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDMainTableViewController.h"
#import "SDPost.h"
#import "SDHole.h"
#import "Constants.h"
#import "SDPostTableViewCell.h"
#import "SDLoginViewController.h"
#import "SDTabViewController.h"
@interface SDMainTableViewController () {
    NSMutableArray *dataSource;
    UIRefreshControl *refresh;
}



@end

@implementation SDMainTableViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPosts) name:DidLoadMyHolesNotif object:nil];
    
    self.selectedRow = -1;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"树洞";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden = NO;
    /*
    if (![AVUser currentUser]) {
        SDLoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:vc animated:NO completion:^{
            //do nothing for now
        }];
    }
     */
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"post" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.tabBarController setHidesBottomBarWhenPushed:YES];
    //[(SDTabViewController*)self.tabBarController hideButton:YES];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewPicture"];
    [self.navigationController pushViewController:vc animated:YES];
    /*
    if (self.selectedRow == indexPath.row) {
        self.selectedRow = -1;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    } else {
        self.selectedRow = indexPath.row;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    */
    
    
}
- (void)loadPosts {
    if ([SDUtils sharedInstance].myHoles != nil) {
        
        
        [[self postQuery] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                dataSource = [NSMutableArray arrayWithArray:objects];
            } else {
                //do nothing by far
            }
        }];
        
        
    } else {
        [[SDUtils sharedInstance] loadMyHoles];
    }
}


/***** query ******/

- (AVQuery *)postQuery {
    AVQuery *postQuery = [SDPost query];
    postQuery.limit = NUMBER_OF_POSTS_PER_LOAD;
    postQuery.cachePolicy = kAVCachePolicyCacheThenNetwork;
    [postQuery whereKey:@"holes" containedIn:[SDUtils sharedInstance].myHoles];
    return nil;
}



#pragma mark Delegate Methods


-(void)didFinishPreparingNewPostToUpload:(SDPost *)newPost {
    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        } else {
            [SDUtils showErrALertWithText:@"发送失败,请检查网络状态"];
        }
    }];
}



/**********/

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
