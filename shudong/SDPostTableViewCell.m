//
//  SDPostTableViewCell.m
//  shudong
//
//  Created by Eric Tao on 4/28/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDPostTableViewCell.h"

@implementation SDPostTableViewCell

@synthesize picture, text;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setNumbers
{
    [self.likeButton setTitle:[@"  " stringByAppendingString:(self.post.likeCount)? [self.post.likeCount stringValue]:@"0"] forState:UIControlStateNormal];
    [self.commentButton setTitle:[@"  " stringByAppendingString:(self.post.commentCount)? [self.post.commentCount stringValue]:@"0"] forState:UIControlStateNormal];
}
-(void)showPictureWithData:(NSData *)data {
    picture.image = [UIImage imageWithData:data];
    picture.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^{
        picture.alpha = 1;
    }completion:^(BOOL finished) {
        text.alpha = 0;
        text.text = _post.text;
        [UIView animateWithDuration:0.4 animations:^{
            text.alpha = 1;
        }];
    }];
}
- (IBAction)like:(id)sender {
    /*
    [self.likeButton.imageView setImage:[UIImage imageNamed:@"liked.png"]];
    [self.likeButton setImage:[UIImage imageNamed:@"liked.png"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"liked.png"] forState:UIControlStateReserved];
    [self.likeButton setImage:[UIImage imageNamed:@"liked.png"] forState:UIControlStateSelected];
     */
    [self.post incrementKey:@"likeCount" byAmount:[NSNumber numberWithInt:1]];
    
    /*
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.likeButton.imageView setAlpha:0];
                     } completion:^(BOOL finished) {
                         [self.likeButton setImage:[UIImage imageNamed:@"liked.png"] forState:UIControlStateNormal];
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              [self.likeButton.imageView setAlpha:1];
                                          }];
                     }];
     */
}

@end
