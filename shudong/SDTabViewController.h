//
//  SDTabViewController.h
//  shudong
//
//  Created by admin on 14-4-26.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDTabViewController : UITabBarController
@property (nonatomic,strong) UIButton* button;
- (void)hideButton:(BOOL)hide;
@end
