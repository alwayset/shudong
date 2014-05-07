//
//  SDActitityCell.m
//  shudong
//
//  Created by admin on 14-5-7.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "SDActitityCell.h"

@implementation SDActitityCell
@synthesize imageview;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
//        self.progressHud  = [[MBProgressHUD alloc] initWithView:self];
//        self.progressHud.mode = MBProgressHUDModeAnnularDeterminate;
//        self.progressHud.hidden = YES;
//       [self addSubview:self.progressHud];

    }
    return self;
}



- (void)showThumbnailWithData:(NSData *)data {
//    self.progressHud.hidden = YES;
    self.imageview.alpha = 0;
    self.imageview.image = [UIImage imageWithData:data];
    [UIView animateWithDuration:0.4 animations:^{
        self.imageview.alpha = 1;
    }];
    self.userInteractionEnabled = YES;
    /*
    for (int eachTag = 2; eachTag < 8; eachTag++) {
        UIView *eachViewToPop = [self viewWithTag:eachTag];
        float showUpDelay = ((float)rand() / RAND_MAX) * 0.8;
        eachViewToPop.alpha = 0;
        CGRect originalFrame = eachViewToPop.frame;
        CGRect fromFrame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y + 8, originalFrame.size.width, originalFrame.size.height);
        eachViewToPop.frame = fromFrame;
        [UIView animateWithDuration:0.2 delay:showUpDelay options:UIViewAnimationOptionCurveEaseIn animations:^{
            eachViewToPop.alpha = 0.7;
            eachViewToPop.frame = originalFrame;
        } completion:^(BOOL finished) {
            //
        }];
    }
     */
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
