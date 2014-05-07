//
//  SDViewPictureViewController.h
//  shudong
//
//  Created by admin on 14-5-1.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPost.h"
@interface SDViewPictureViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextView *inputComment;
@property (strong, nonatomic) IBOutlet UIView *inputView;
@property (strong, nonatomic) IBOutlet UIView *commentBar;
@property (strong, nonatomic) NSIndexPath* indexPathInMain;
@property (nonatomic,strong) SDPost* parentPost;
@end
