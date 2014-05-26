//
//  SDPostTableViewCell.h
//  shudong
//
//  Created by Eric Tao on 4/28/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPost.h"
#import "SDLikeButton.h"
#import "CERoundProgressView.h"
@interface SDPostTableViewCell : UITableViewCell


//@property (strong, nonatomic) IBOutlet UIImageView *picture;
//@property (strong, nonatomic) IBOutlet UILabel *text;
//@property (strong, nonatomic) IBOutlet SDLikeButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
//@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (strong, nonatomic) NSIndexPath* indexPathInMain;
@property (nonatomic, strong) SDPost *post;
//@property (strong, nonatomic) IBOutlet CERoundProgressView *likeProgress;
@property (strong, nonatomic) IBOutlet UITextView *contentText;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UIButton *upButton;
@property (strong, nonatomic) IBOutlet UIButton *downButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;

@property (strong, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeStampLabel;


//- (void)showPictureWithData:(NSData *)data;
//- (void)setNumbers;
- (void)setShadow;

@end
