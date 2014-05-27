//
//  SDPostTableViewCell.m
//  shudong
//
//  Created by Eric Tao on 4/28/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDPostTableViewCell.h"
#import "SDUtils.h"
#import "Constants.h"
#import "SDViewPictureViewController.h"

@implementation SDPostTableViewCell

@synthesize contentText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
//    sourceLabel.font = [UIFont fontWithName:FONT_1 size:12.0];
//    titleLabel.font = [UIFont fontWithName:FONT_1 size:17.0];
//    text.font = [UIFont fontWithName:FONT_1 size:15.0];
//    
//    
//    UIColor *tintColor = [UIColor colorWithRed:252.0/255.0 green:62.0/255.0 blue:73.0/255.0 alpha:1];
//    [[UISlider appearance] setMinimumTrackTintColor:tintColor];
//    [[CERoundProgressView appearance] setTintColor:tintColor];
//    self.likeProgress.trackColor = [UIColor colorWithWhite:0.95 alpha:1.0];
//    self.likeProgress.startAngle = (3.0*M_PI)/2.0;
    

}
//- (void)setShadow
//{
//    containerView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//    containerView.layer.shadowOpacity = 0.7f;
//    containerView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
//    containerView.layer.shadowRadius = 3.0f;
//    containerView.layer.masksToBounds = NO;
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:containerView.bounds];
//    containerView.layer.shadowPath = path.CGPath;
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setNumbers
{
//    [self.likeButton setText:(self.post.likeCount)? [self.post.likeCount stringValue]:@"0"];
//    [self.commentButton setTitle:[@"  " stringByAppendingString:(self.post.commentCount)? [self.post.commentCount stringValue]:@"0"] forState:UIControlStateNormal];
//    [self.likeButton initRedHeart:[[[SDUtils sharedInstance] myLikes] containsObject:self.post]];
}

-(void)showPictureWithData:(NSData *)data
{
////    picture.image = [UIImage imageWithData:data];
//    picture.alpha = 0;
//    [UIView animateWithDuration:0.1 animations:^{
//        picture.alpha = 1;
//    }completion:^(BOOL finished) {
//    }];
}
- (IBAction)comment:(id)sender {
    //[[NSNotificationCenter defaultCenter] postNotificationName:ShouldHideTabbarNotif object:nil];
    
    SDViewPictureViewController *vc = [self.parentVC.storyboard instantiateViewControllerWithIdentifier:@"ViewPicture"];
    vc.parentPost = self.post;
    vc.indexPathInMain = self.indexPathInMain;
    [self.parentVC.navigationController pushViewController:vc animated:YES];
}
- (IBAction)follow:(id)sender {
    [[AVUser currentUser] follow:self.post.poster.objectId andCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"关注成功"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
        
        }
    }];
}

- (IBAction)like:(id)sender {

    
    
//    BOOL liked = false;
//    for (SDPost* i in [[SDUtils sharedInstance] myLikes])
//        if ([i.objectId isEqualToString:self.post.objectId]) {
//            liked = true;break;
//        }
    if ([[[SDUtils sharedInstance] myLikes] containsObject:self.post]) {
        [self.post incrementKey:@"likeCount" byAmount:[NSNumber numberWithInt:-1]];
        [[[SDUtils sharedInstance] myLikes] removeObject:self.post];
        [[self.post relationforKey:@"likedBy"] removeObject:[AVUser currentUser]];
        [self.likeButton setRedHeart:NO WithText:[self.post.likeCount stringValue]];
        
    } else {
        [self.post incrementKey:@"likeCount" byAmount:[NSNumber numberWithInt:1]];
        [[[SDUtils sharedInstance] myLikes] addObject:self.post];
        [[self.post relationforKey:@"likedBy"] addObject:[AVUser currentUser]];
        [self.likeButton setRedHeart:YES WithText:[self.post.likeCount stringValue]];
    }
//    [self.likeButton setText:[self.post.likeCount stringValue]];
    [self.post saveEventually:^(BOOL succeeded, NSError *error) {
        /*
        if (succeeded) {
            AVStatus *likeStatus = [[AVStatus alloc] init];
            AVQuery *query = [AVUser query];
            [query whereKey:@"objectId" equalTo:self.post.poster.objectId];
            [likeStatus setQuery:query];
            likeStatus.type = @"news";
            likeStatus.data = @{@"text":@"有人赞了你的秘密", @"type":[NSNumber numberWithInt:NewsLikeType], @"postObjectId":self.post.objectId};
            [likeStatus sendInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                //do something;
                if (error) {
                    NSLog(@"like status error: %@", error);
                }
            }];

        }
         */
    }];
    if (self.indexPathInMain) [[NSNotificationCenter defaultCenter] postNotificationName:LikedAPostNotif object:self.indexPathInMain];
//    

}

@end
