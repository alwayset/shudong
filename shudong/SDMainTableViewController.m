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
#import "KxMenu.h"
#import "CERoundProgressView.h"
#import "SDLikeButton.h"
#import <MBProgressHUD/MBProgressHUD.h>

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
    
    
    if (![AVUser currentUser]) {
        [self signup];
    }
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadPosts) name:DidLoadPostsNotif object:nil];

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


-(void)signup {
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"初始化中..";
    
    
    NSError *err;
    
    AVUser * user = [AVUser user];
    user.username = [self genRandStringLength];
    AVQuery *usernameAvailabilityQuery = [AVUser query];
    [usernameAvailabilityQuery whereKey:@"username" equalTo:user.username];
    [usernameAvailabilityQuery getFirstObject:&err];
    if (err.code == kAVErrorObjectNotFound) { //随机生成的用户没有被注册
        user.password = @"888888";
        user[@"score"] = @0;
        user[@"postCount"] = @0;
        user[@"registered"] = [NSNumber numberWithBool:NO];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [hud hide:YES];
            if (succeeded) {
            } else {
            }
            return;
        }];
    } else if (err) { //网不好
        [hud hide:YES];
        [SDUtils showErrALertWithText:@"网络不好"];
        return;
    } else {  //随机生成的用户名有重复，这极不可能发生
        [hud hide:YES];
        [self signup];
        return;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    
    [self loadPosts];

//    if (![AVUser currentUser]) {
//        SDLoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
//        [self presentViewController:vc animated:NO completion:^{
//            //do nothing for now
//        }];
//    } else {
////        if (firstLoad) {
////            [refresh beginRefreshing];
////            [[SDUtils sharedInstance] loadPosts];
////            [[SDUtils sharedInstance] loadNewsArr];
////            firstLoad = NO;
////        } else {
////        }
//
//    }
    
    
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDPost *currentPost = dataSource[indexPath.row];
    NSString* temp = currentPost.text;
    //CGSize size = [temp sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(320,500) lineBreakMode:UILineBreakModeWordWrap];
    CGRect rect = [temp boundingRectWithSize:CGSizeMake(272, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil];
    return  rect.size.height + 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    SDPostTableViewCell *cell = (SDPostTableViewCell *  )[tableView dequeueReusableCellWithIdentifier:@"post" forIndexPath:indexPath];
    SDPost *currentPost = dataSource[indexPath.row];
    cell.post = currentPost;
    
    if (currentPost.displayName) {
        cell.displayNameLabel.text = currentPost.displayName;
        cell.displayNameLabel.textColor = [UIColor blackColor];
    } else {
        cell.displayNameLabel.textColor = [UIColor lightGrayColor];
        cell.displayNameLabel.text = @"匿名用户";
    }
    
    if (currentPost[@"terr"]) {
        [cell.terrButton setHidden:NO];
        [cell.terrButton setTitle:currentPost[@"terr"][@"name"] forState:UIControlStateNormal];
    } else {
        [cell.terrButton setHidden:YES];
    }
    //cell.contentText.text = currentPost.text;
    cell.textLabel.text = currentPost.text;
    //    [cell.contentText sizeToFit];
    

    cell.commentButton.titleLabel.text = [@" " stringByAppendingString:currentPost.commentCount.stringValue];
    CGRect rect = [currentPost.text boundingRectWithSize:CGSizeMake(272, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil];
    cell.textLabel.frame = CGRectMake(24, 26, rect.size.width, rect.size.height+6);
    //[cell.contentText setContentInset:UIEdgeInsetsMake(-5, -5, 0, -15)];
    
    cell.toolBar.frame = CGRectMake(0, rect.size.height + 68 - cell.toolBar.frame.size.height, 320, cell.toolBar.frame.size.height);
    [cell.likeButton setText:[currentPost.likeCount stringValue]];
    [cell.likeButton initRedHeart:[[[SDUtils sharedInstance] myLikes] containsObject:currentPost]];
    cell.parentVC = self;
    
//    cell.titleLabel.text = currentPost[@"title"];
//    cell.titleLabel.text = @"清华大学北大系";
//    [cell.sourceLabel sizeToFit];
//    CGRect rect = [currentPost.text boundingRectWithSize:CGSizeMake(290, 200) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]} context:nil];
//    [cell.text setFrame:CGRectMake(23, 30, 274, (rect.size.height<142)?rect.size.height:75)];
//    cell.text.text = currentPost.text;
//    [cell.likeProgress setFrame:CGRectMake(249, cell.text.frame.size.height+30+20, 50, 50)];
    
//    [cell setShadow];
//    if (!currentPost.image) {
//        cell.picture.image = [UIImage imageNamed:[currentPost.picId.stringValue stringByAppendingString:@".jpg"]];
//    } else {
//        cell.picture.image = nil;
//        [self startLoading:currentPost forIndexPath:indexPath cell:cell];
//    }
//    [cell setNumbers];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell.likeProgress setProgress:0.65 animated:YES];
    return cell;
}

//- (void)startLoading:(SDPost *)post forIndexPath:(NSIndexPath *)indexpath cell:(SDPostTableViewCell *)targetCell {
//    AVFile *fileToDownload = [filesInDownload objectForKey:indexpath];
//    if (fileToDownload == nil)
//    {
//        fileToDownload = post.image;
//        [filesInDownload setObject:fileToDownload forKey:indexpath];
//        [fileToDownload getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//            if (!error) {
//                SDPostTableViewCell *cell = (SDPostTableViewCell *)[self.tableview cellForRowAtIndexPath:indexpath];
//                if (cell == nil && [targetCell.post.objectId isEqualToString:post.objectId]) {
//                    cell = targetCell;
//                }
//                [cell showPictureWithData:data];
//                [filesInDownload removeObjectForKey:indexpath];
//            }
//        }];
//    }
//}


- (IBAction)categoryClicked:(UIButton*)sender {
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"李零"
                     image:nil
                    target:self
                    action:NULL],
      [KxMenuItem menuItem:@"王一"
                     image:nil
                    target:self
                    action:NULL],
      [KxMenuItem menuItem:@"张三"
                     image:nil
                    target:self
                    action:NULL],
      [KxMenuItem menuItem:@"李四"
                     image:nil
                    target:self
                    action:NULL],
      ];
    
    KxMenuItem *first = menuItems[0];
    //first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view.window
                  fromRect:CGRectMake(sender.frame.origin.x, sender.frame.origin.y+8, sender.frame.size.width, sender.frame.size.height)
                 menuItems:menuItems];

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
    [postQuery includeKey:@"terr"];
    if (firstLoad) {
        postQuery.cachePolicy = kAVCachePolicyCacheThenNetwork;
        firstLoad = NO;
    } else {
        postQuery.cachePolicy = kAVCachePolicyNetworkOnly;
    }
    
    //[postQuery whereKey:@"holes" containedIn:[SDUtils sharedInstance].myHoles];
    return postQuery;
}



#pragma mark notification Methods


//-(void)didFinishPreparingNewPostToUpload:(NSNotification *)notif {
//    NSDictionary *package = notif.object;
//    SDPost *newPost = package[@"post"];
//    AVFile *newFile = package[@"file"];
//
//    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            if (newFile != nil) {
//                [newFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                    if (succeeded) {
////                        newPost.image = newFile;
//                        [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                            if (succeeded) {
//                                [[SDUtils sharedInstance] loadPosts];
//                            } else {
//                                [SDUtils showErrALertWithText:@"发布失败,请检查网络"];
//                            }
//                        }];
//                    } else {
//                        [SDUtils showErrALertWithText:@"发布失败,请检查网络"];
//                    }
//                }];
//            }
//            [[[AVUser currentUser] relationforKey:@"subscribe"] addObject:newPost];
//            [[AVUser currentUser] saveEventually];
//            [[SDUtils sharedInstance] loadPosts];
//        } else {
//            [SDUtils showErrALertWithText:@"发布失败,请检查网络"];
//        }
//    }];
//}



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


-(NSString *) genRandStringLength {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:20];
    
    for (int i=0; i<20; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}



@end
