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


@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *text;
@property (strong, nonatomic) IBOutlet SDLikeButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (strong, nonatomic) NSIndexPath* indexPathInMain;
@property (nonatomic, strong) SDPost *post;
@property (strong, nonatomic) IBOutlet CERoundProgressView *likeProgress;

- (void)showPictureWithData:(NSData *)data;
- (void)setNumbers;


@end
