//
//  SDActivitiesCenterViewController.m
//  shudong
//
//  Created by admin on 14-5-7.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "SDActivitiesCenterViewController.h"
#import "SDUtils.h"
#import "SDActitityCell.h"
#import "SDPost.h"
@interface SDActivitiesCenterViewController ()

@end

@implementation SDActivitiesCenterViewController
@synthesize nothingTipLabel,nothingTipView;
@synthesize filesInDownload;
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    nothingTipView.hidden = YES;
    if ([SDUtils sharedInstance].newsArr.count == 0) {
        nothingTipView.hidden = NO;
        return 1;
    } else {
        return [SDUtils sharedInstance].newsArr.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1; //1 for now.
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SDActitityCell *cell = (SDActitityCell *)[cv dequeueReusableCellWithReuseIdentifier:@"activity" forIndexPath:indexPath];
    
//    [cell.newsView removeFromSuperview];
//    cell.newsView = nil;
    SDPost* post = [[SDUtils sharedInstance].newsArr objectAtIndex:indexPath.item];
        
    UIView *newsInfoView = [[UIView alloc] initWithFrame:cell.bounds];
    newsInfoView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    newsInfoView.userInteractionEnabled = YES;
    /*
    NSDictionary *counts = [manager.newsWODict objectForKey:object.objectId];
    NSNumber *likeCount = counts[@"like"];
    NSNumber *commentCount = counts[@"comment"];
        if (likeCount.intValue > 0) {
            UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 72, 158.5, 20)];
            likeLabel.font = [UIFont fontWithName:FONT_1 size:14.0f];
            likeLabel.textColor = [UIColor blackColor];
            likeLabel.textAlignment = NSTextAlignmentCenter;
            likeLabel.text = [NSString stringWithFormat:@"%@个赞", likeCount];
            [newsInfoView addSubview:likeLabel];
        }
        
        if (commentCount.intValue > 0) {
            UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 102, 158.5, 20)];
            commentLabel.font = [UIFont fontWithName:FONT_1 size:14.0f];
            commentLabel.textColor = [UIColor blackColor];
            commentLabel.textAlignment = NSTextAlignmentCenter;
            commentLabel.text = [NSString stringWithFormat:@"%@个回复", commentCount];
            [newsInfoView addSubview:commentLabel];
        }
        
    */
    [cell addSubview:newsInfoView];
    cell.post = post;
    
    //cell.likesCountLabel.text = [NSString stringWithFormat:@"%@",object.likesCount];
    //if (object.commentCount) cell.commentsCountLabel.text = [NSString stringWithFormat:@"%@",object.commentCount];
    //else cell.commentsCountLabel.text = @"0";
    //cell.postTimeLabel.text = [PaDataManager getTimeStr:object.createdAt];
    //cell.postTimeLabel.font = [UIFont fontWithName:FONT_1 size:11.0f];
    
    //[cell fit];
    
    
    //cell.imageview.image = nil;
    //[self startLoading:post forIndexPath:indexPath cell:cell collectionView:cv];
    return cell;
    
}
- (void)startLoading:(SDPost *)post forIndexPath:(NSIndexPath *)indexpath cell:(SDActitityCell *)targetCell collectionView:(UICollectionView *)cv {
    AVFile *fileToDownload = [filesInDownload objectForKey:indexpath];
    
    if (fileToDownload == nil)
    {
        fileToDownload = post.image;
        [filesInDownload setObject:fileToDownload forKey:indexpath];
        [fileToDownload getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error ){ //&& [PaDataManager isJPEGValid:data]) {
                SDActitityCell *cell = (SDActitityCell *)[cv cellForItemAtIndexPath:indexpath];
                if (cell == nil && [targetCell.post.objectId isEqualToString:post.objectId]) {
                    cell = targetCell;
                }
                [cell showThumbnailWithData:data];
                [filesInDownload removeObjectForKey:indexpath];
            }
        } progressBlock:^(NSInteger percentDone) {
            //SDActitityCell *cell = (SDActitityCell *)[cv cellForItemAtIndexPath:indexpath];
            //if (percentDone != 100) {
                //cell.progressHud.hidden = NO;
                //[cell.progressHud show:NO];
                //cell.progressHud.progress = percentDone / 100.0;
            //} else {
                //cell.progressHud.hidden = YES;
            //}
        }];
    }
}
@end
