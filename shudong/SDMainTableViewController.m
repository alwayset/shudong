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
@interface SDMainTableViewController () {
    NSMutableArray *dataSource;
    UIRefreshControl *refresh;
}



@end

@implementation SDMainTableViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadMyHoles) name:DidLoadMyHolesNotif object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishPreparingNewPostToUpload:) name:DidFinishPreparingWithNewPostNotif object:nil];
    
    refresh = [[UIRefreshControl alloc] init];
    [self.tableview addSubview:refresh];
    [refresh addTarget:self action:@selector(loadPosts) forControlEvents:UIControlEventValueChanged];
    
    self.selectedRow = -1;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = YES;
    



    if (![AVUser currentUser]) {
        SDLoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:vc animated:NO completion:^{
            //do nothing for now
        }];
    } else {
        [self loadPosts];

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

- (void)didLoadMyHoles {
    if ([SDUtils sharedInstance].myHoles) {
        [self loadPosts];
    }
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDPostTableViewCell *cell = (SDPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"post" forIndexPath:indexPath];
    
    SDPost *currentPost = dataSource[indexPath.row];
    cell.text.text = currentPost.text;
    
    if (currentPost.picId) {
        cell.picture.image = [UIImage imageNamed:[currentPost.picId.stringValue stringByAppendingString:@".jpg"]];
    }

    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.tabBarController setHidesBottomBarWhenPushed:YES];
    //[(SDTabViewController*)self.tabBarController hideButton:YES];
    SDViewPictureViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewPicture"];
    vc.parentPost = [dataSource objectAtIndex:indexPath.row];
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



/***** query ******/

- (AVQuery *)postQuery {
    AVQuery *postQuery = [SDPost query];
    [postQuery orderByDescending:@"createdAt"];
    postQuery.limit = NUMBER_OF_POSTS_PER_LOAD;
    postQuery.cachePolicy = kAVCachePolicyCacheThenNetwork;
    //[postQuery whereKey:@"holes" containedIn:[SDUtils sharedInstance].myHoles];
    return postQuery;
}



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
                                [self loadPosts];
                            } else {
                                [SDUtils showErrALertWithText:@"发布失败,请检查网络"];
                            }
                        }];
                    } else {
                        [SDUtils showErrALertWithText:@"发布失败,请检查网络"];
                    }
                }];
            }
            [self loadPosts];
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
