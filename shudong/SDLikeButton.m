//
//  SDLikeButton.m
//  shudong
//
//  Created by admin on 14-5-6.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "SDLikeButton.h"

@implementation SDLikeButton
@synthesize buttonImage;
@synthesize label;
@synthesize imageRect;
@synthesize redImage;
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
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        buttonImage = [[UIImageView alloc] init];
        redImage = [[UIImageView alloc] init];
        //[self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
        [buttonImage setImage:[UIImage imageNamed:@"likeB.png"]];
        [redImage setImage:[UIImage imageNamed:@"liked.png"]];
        [label setTextColor:[UIColor lightGrayColor]];
        [label setText:@"0"];
        [label sizeToFit];
        [buttonImage setFrame:CGRectMake(8, (self.frame.size.height-20)/2, 20, 20)];
        [redImage setFrame:CGRectMake(8, (self.frame.size.height-20)/2, 20, 20)];
        [redImage setAlpha:0];
        imageRect = buttonImage.frame;
        [label setFrame:CGRectMake(buttonImage.frame.origin.x + 28, (self.frame.size.height-20)/2, label.frame.size.width, 20)];
        
        [self addSubview:buttonImage];
        [self addSubview:redImage];
        [self addSubview:label];
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
- (void)setText:(NSString*)text {
    label.text = text;
    [label sizeToFit];
    [buttonImage setFrame:CGRectMake(8, (self.frame.size.height-20)/2, 20, 20)];
    [redImage setFrame:CGRectMake(8, (self.frame.size.height-20)/2, 20, 20)];
    imageRect = buttonImage.frame;
    [label setFrame:CGRectMake(buttonImage.frame.origin.x + 28, (self.frame.size.height-20)/2, label.frame.size.width, 20)];
}

- (void)setRedHeart:(BOOL)like WithText:(NSString*)text{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                            [redImage setAlpha:like];
                        }
                     completion:^(BOOL finished) {
                            [self setText:text];
                        }];
    
}

- (void)initRedHeart:(BOOL)like {
    [redImage setAlpha:like];
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [buttonImage setFrame:CGRectMake(imageRect.origin.x - 3, imageRect.origin.y - 3, 26, 26)];
                             if (!redImage.hidden) [redImage setFrame:CGRectMake(imageRect.origin.x - 3, imageRect.origin.y - 3, 26, 26)];
                             
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    } else {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [buttonImage setFrame:imageRect];
                             if (!redImage.hidden) [redImage setFrame:imageRect];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    
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
