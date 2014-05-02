//
//  SDViewPictureViewController.m
//  shudong
//
//  Created by admin on 14-5-1.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "SDViewPictureViewController.h"
#import "SDPostTableViewCell.h"
#import "SDCommentCell.h"
#import "SDComment.h"
#import "SDUtils.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface SDViewPictureViewController () {
    UIRefreshControl *refresh;
}

@end

@implementation SDViewPictureViewController
@synthesize parentPost;
@synthesize inputComment;
@synthesize inputView;
@synthesize tableView;
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
    
    [self loadComments];
    
    refresh = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refresh];
    [refresh addTarget:self action:@selector(loadComments) forControlEvents:UIControlEventValueChanged];
    
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    //[self setHidesBottomBarWhenPushed:YES];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) return 1;
    else return parentPost.commentsArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) return 320;
    else return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            SDPostTableViewCell *cell = (SDPostTableViewCell *)[tv dequeueReusableCellWithIdentifier:@"post" forIndexPath:indexPath];
            cell.text.text = parentPost.text;
            
            if (parentPost.picId) {
                cell.picture.image = [UIImage imageNamed:[parentPost.picId.stringValue stringByAppendingString:@".jpg"]];
            }
            return cell;
            break;
        }
        case 1: {
            SDCommentCell *cell = (SDCommentCell *) [tv dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
            SDComment* comment = [parentPost.commentsArr objectAtIndex:indexPath.row];
            cell.text.text = comment.text;
            cell.time.text = [[SDUtils getTimeStr:comment.createdAt] stringByAppendingFormat:@"  %d楼", indexPath.row+1];
            // Configure the cell...
            
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
    
}
-(void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         [inputView setFrame:CGRectMake(0, [SDUtils screenHeight] -height-inputView.frame.size.height, 320, inputView.frame.size.height)];
                         [tableView setFrame:CGRectMake(0, 0, 320, self.inputView.frame.origin.y)];
                         if (parentPost.commentsArr.count > 0) {
                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:parentPost.commentsArr.count - 1 inSection:1]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                         }

                     } completion:^(BOOL finished) {
//                         if (parentPost.commentsArr.count > 0) {
//                             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:parentPost.commentsArr.count - 1 inSection:1]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//                         }
                     }];
}
-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [inputView setFrame:CGRectMake(0,  [SDUtils screenHeight] - inputView.frame.size.height, 320, inputView.frame.size.height)];
                         [self.tableView setFrame:CGRectMake(0, 0, 320, Screen_Height - inputView.frame.size.height)];
                     } completion:^(BOOL finished) {


                     }];
}
- (IBAction)sendComment:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"发布评论中";
    [inputComment resignFirstResponder];
    SDComment* comment = [SDComment object];
    comment.text = inputComment.text;
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (succeeded) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            [parentPost.comments addObject:comment];
            [parentPost incrementKey:@"commentCount"];
            [parentPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self loadComments];
                    hud.labelText = @"评论成功";
                    [hud hide:YES afterDelay:0.2];
                } else {
                    hud.labelText = @"评论失败";
                    [hud hide:YES afterDelay:0.4];
                }
                inputComment.text = @"";

            }];
        } else {
            hud.labelText = @"评论失败";
            [hud hide:YES afterDelay:0.4];
        }
    }];
    
}

- (void)loadComments
{
    [refresh beginRefreshing];
    
    [[self commentsQuery] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [refresh endRefreshing];
        
        if (error) {
            
        } else {
            parentPost.commentsArr = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (parentPost.commentsArr.count > 0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:parentPost.commentsArr.count - 1 inSection:1]  atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }
        }
    }];
}
- (AVQuery*)commentsQuery
{
    AVQuery *query = [parentPost.comments query];
    [query orderByAscending:@"createdAt"];
    query.cachePolicy = kAVCachePolicyCacheThenNetwork;
    return query;
    
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