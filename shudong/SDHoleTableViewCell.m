//
//  SDHoleTableViewCell.m
//  shudong
//
//  Created by Eric Tao on 4/29/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDHoleTableViewCell.h"

@implementation SDHoleTableViewCell

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

@end
