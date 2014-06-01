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
#import "SDMainTableViewController.h"
@interface SDPostTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *toolBar;



@property (strong, nonatomic) IBOutlet SDLikeButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) NSIndexPath* indexPathInMain;
@property (nonatomic, strong) SDPost *post;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentText;
@property (strong, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UIButton *terrButton;


@property (strong, nonatomic) SDMainTableViewController* parentVC;

//- (void)showPictureWithData:(NSData *)data;
//- (void)setNumbers;
//- (void)setShadow;

@end
