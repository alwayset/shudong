//
//  SDCategoryButton.m
//  shudong
//
//  Created by admin on 14-5-20.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "SDCategoryButton.h"

@implementation SDCategoryButton
@synthesize triangle;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        triangle = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-3, self.frame.size.height-9, 6, 6)];
        [triangle setImage:[UIImage imageNamed:@"triangle.png"]];
        [self addSubview:triangle];

    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setHighlighted:(BOOL)highlighted
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         [triangle setTransform:CGAffineTransformMakeRotation(M_PI)];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                          animations:^{
                                              [triangle setTransform:CGAffineTransformMakeRotation(M_PI*2)];
                                          }];
                     }];
}
@end
