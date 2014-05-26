//
//  SDLikeButton.h
//  shudong
//
//  Created by admin on 14-5-6.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDLikeButton : UIButton
@property (nonatomic, retain) UIImageView* buttonImage;
@property (nonatomic, retain) UIImageView* redImage;
@property (nonatomic, retain) UILabel* label;
@property (nonatomic) CGRect imageRect;
- (void)setText:(NSString*)text;
- (void)setRedHeart:(BOOL)like WithText:(NSString*)text;
- (void)initRedHeart:(BOOL)like;
@end
