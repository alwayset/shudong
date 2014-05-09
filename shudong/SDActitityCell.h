//
//  SDActitityCell.h
//  shudong
//
//  Created by admin on 14-5-7.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPost.h"
@interface SDActitityCell : UICollectionViewCell
//@property (strong, nonatomic) MBProgressHUD *progressHud;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) SDPost* post;
@property (strong, nonatomic) UIView* newsView;
- (void)showThumbnailWithData:(NSData *)data;
@end
