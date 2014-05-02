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

@end
