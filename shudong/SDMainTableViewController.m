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
#import "SDViewPictureViewController.h"
#import "SDHoleFilterTableViewController.h"
#import "SDAddPostViewController.h"

@interface SDMainTableViewController () {
    NSMutableArray *dataSource;
    UIRefreshControl *refresh;
    BOOL firstLoad;
}


@property NSMutableDictionary *filesInDownload;
@end

@implementation SDMainTableViewController
@synthesize filesInDownload;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadMyHoles) name:DidLoadMyHolesNotif object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadPosts) name:DidLoadPostsNotif object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishPreparingNewPostToUpload:) name:DidFinishPreparingWithNewPostNotif object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLike:) name:LikedAPostNotif object:nil];
    
    refresh = [[UIRefreshControl alloc] init];
    [self.tableview addSubview:refresh];
    [refresh addTarget:[SDUtils sharedInstance] action:@selector(loadPosts) forControlEvents:UIControlEventValueChanged];
    
    self.selectedRow = -1;
    filesInDownload = [[NSMutableDictionary alloc] init];
    firstLoad = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];


    if (![AVUser currentUser]) {
        SDLoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:vc animated:NO completion:^{
            //do nothing for now
        }];
    } else {
        if (firstLoad) {
            [refresh beginRefreshing];
            [[SDUtils sharedInstance] loadPosts];
            [[SDUtils sharedInstance] loadNewsArr];
            
            firstLoad = NO;
        } else {
        }

    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)didLoadMyHoles {
    if ([SDUtils sharedInstance].myHoles) {
        [[SDUtils sharedInstance] loadPosts];
    }
}
 */
- (void)didLoadPosts {
    [refresh endRefreshing];
    dataSource = [SDUtils sharedInstance].postsArr;
    [self.tableview reloadData];
}
- (void)reloadLike:(NSNotification*)notif
{
    [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:notif.object] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    return dataSource.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 250;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDPostTableViewCell *cell = (SDPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"post" forIndexPath:indexPath];
    
    SDPost *currentPost = dataSource[indexPath.row];
    cell.post = currentPost;
    cell.titleLabel.text = currentPost[@"title"];
//    cell.titleLabel.text = @"清华大学北大系";
    cell.sourceLabel.text = @"清华大学北大系";
    cell.text.text = currentPost.text;
    if (!currentPost.image) {
        cell.picture.image = [UIImage imageNamed:[currentPost.picId.stringValue stringByAppendingString:@".jpg"]];
    } else {
        cell.picture.image = nil;
        [self startLoading:currentPost forIndexPath:indexPath cell:cell];
    }
    [cell setNumbers];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Configure the cell...
    
    return cell;
}

- (void)startLoading:(SDPost *)post forIndexPath:(NSIndexPath *)indexpath cell:(SDPostTableViewCell *)targetCell {
    AVFile *fileToDownload = [filesInDownload objectForKey:indexpath];
    if (fileToDownload == nil)
    {
        fileToDownload = post.image;
        [filesInDownload setObject:fileToDownload forKey:indexpath];
        [fileToDownload getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                SDPostTableViewCell *cell = (SDPostTableViewCell *)[self.tableview cellForRowAtIndexPath:indexpath];
                if (cell == nil && [targetCell.post.objectId isEqualToString:post.objectId]) {
                    cell = targetCell;
                }
                [cell showPictureWithData:data];
                [filesInDownload removeObjectForKey:indexpath];
            }
        }];
    }
}



- (IBAction) addPost {
    SDAddPostViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addpost"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.tabBarController setHidesBottomBarWhenPushed:YES];
    //[(SDTabViewController*)self.tabBarController hideButton:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ShouldHideTabbarNotif object:nil];
    
    SDViewPictureViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewPicture"];
    vc.parentPost = [dataSource objectAtIndex:indexPath.row];
    vc.indexPathInMain = indexPath;
    [self.navigationController pushViewController:vc animated:YES];
    
//    SDTabViewController *tabbar = (SDTabViewController *)self.tabBarController;
//    
//    [tabbar.nav pushViewController:vc animated:YES];
//    [self.tabBarController presentViewController:tabbar.nav animated:YES completion:nil];
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
/*
- (void)loadPosts {
    if ([SDUtils sharedInstance].myHoles != nil) {
        [refresh beginRefreshing];
        [[self postQuery] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                dataSource = [NSMutableArray arrayWithArray:objects];
                [self.tableview reloadData];
            } else {
                //do nothing by far
            }
            [refresh endRefreshing];
        }];
    } else {
        [refresh beginRefreshing];
        [[SDUtils sharedInstance] loadMyHoles];
    }
}

- (AVQuery *)postQuery {
    AVQuery *postQuery = [SDPost query];
    [postQuery orderByDescending:@"createdAt"];
    postQuery.limit = NUMBER_OF_POSTS_PER_LOAD;
    
    if (firstLoad) {
        postQuery.cachePolicy = kAVCachePolicyCacheThenNetwork;
        firstLoad = NO;
    } else {
        postQuery.cachePolicy = kAVCachePolicyNetworkOnly;
    }
    
    //[postQuery whereKey:@"holes" containedIn:[SDUtils sharedInstance].myHoles];
    return postQuery;
}

*/

#pragma mark notification Methods


-(void)didFinishPreparingNewPostToUpload:(NSNotification *)notif {
    NSDictionary *package = notif.object;
    SDPost *newPost = package[@"post"];
    AVFile *newFile = package[@"file"];

    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            if (newFile != nil) {
                [newFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        newPost.image = newFile;
                        [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                [[SDUtils sharedInstance] loadPosts];
                            } else {
                                [SDUtils showErrALertWithText:@"发布失败,请检查网络"];
                            }
                        }];
                    } else {
                        [SDUtils showErrALertWithText:@"发布失败,请检查网络"];
                    }
                }];
            }
            [[[AVUser currentUser] relationforKey:@"subscribe"] addObject:newPost];
            [[AVUser currentUser] saveEventually];
            [[SDUtils sharedInstance] loadPosts];
        } else {
            [SDUtils showErrALertWithText:@"发布失败,请检查网络"];
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





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"filter"]) {
        if ([SDUtils sharedInstance].parsedHoles) {
            SDHoleFilterTableViewController *filter = (SDHoleFilterTableViewController *)segue.destinationViewController;
            filter.holesDict = [SDUtils sharedInstance].parsedHoles;
        } else {
            [[SDUtils sharedInstance] loadMyHoles];
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}




@end
