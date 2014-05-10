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
#import "Constants.h"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadNewsArr) name:NewsArrLoadedNotif object:nil];
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
- (void)didLoadNewsArr
{
    [self.collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    nothingTipView.hidden = YES;
    if ([SDUtils sharedInstance].newsPostArr.count == 0) {
        nothingTipView.hidden = NO;
        return 0;
    } else {
        return [SDUtils sharedInstance].newsPostArr.count;
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
    
    [cell.newsView removeFromSuperview];
    cell.newsView = nil;
    SDPost* post = [[SDUtils sharedInstance].newsPostArr objectAtIndex:indexPath.item];
        
    UIView *newsInfoView = [[UIView alloc] initWithFrame:cell.bounds];
    newsInfoView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    newsInfoView.userInteractionEnabled = YES;
    
    NSDictionary *counts = [[SDUtils sharedInstance].newsDict objectForKey:post.objectId];
    NSNumber *likeCount = counts[@"like"];
    NSNumber *commentCount = counts[@"comment"];
        if (likeCount.intValue > 0) {
            UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, 158.5, 20)];
            //likeLabel.font = [UIFont fontWithName:FONT_1 size:14.0f];
            likeLabel.font = [UIFont systemFontOfSize:14.0f];
            likeLabel.textColor = [UIColor blackColor];
            likeLabel.textAlignment = NSTextAlignmentCenter;
            likeLabel.text = [NSString stringWithFormat:@"%@个赞", likeCount];
            [newsInfoView addSubview:likeLabel];
        }
        
        if (commentCount.intValue > 0) {
            UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, 158.5, 20)];
            //commentLabel.font = [UIFont fontWithName:FONT_1 size:14.0f];
            commentLabel.font = [UIFont systemFontOfSize:14.0f];
            commentLabel.textColor = [UIColor blackColor];
            commentLabel.textAlignment = NSTextAlignmentCenter;
            commentLabel.text = [NSString stringWithFormat:@"%@个回复", commentCount];
            [newsInfoView addSubview:commentLabel];
        }
        
    cell.newsView = newsInfoView;
    [cell addSubview:cell.newsView];
    cell.post = post;
    
    //cell.likesCountLabel.text = [NSString stringWithFormat:@"%@",object.likesCount];
    //if (object.commentCount) cell.commentsCountLabel.text = [NSString stringWithFormat:@"%@",object.commentCount];
    //else cell.commentsCountLabel.text = @"0";
    //cell.postTimeLabel.text = [PaDataManager getTimeStr:object.createdAt];
    //cell.postTimeLabel.font = [UIFont fontWithName:FONT_1 size:11.0f];
    
    //[cell fit];
    if (!post.image) {
        cell.imageview.image = [UIImage imageNamed:[post.picId.stringValue stringByAppendingString:@".jpg"]];
    } else {
        cell.imageview.image = nil;
        [self startLoading:post forIndexPath:indexPath cell:cell collectionView:cv];
    }
    
    return cell;
    
}
- (void)clearImagesInDownload {
    for (AVFile *fileToCancel in filesInDownload) {
        [fileToCancel cancel];
    }
    
    [filesInDownload removeAllObjects];
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
