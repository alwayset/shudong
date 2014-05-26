//
//  SDMapCell.m
//  shudong
//
//  Created by admin on 14-5-26.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "SDMapCell.h"

@implementation SDMapCell

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
    [self.mapView.layer setCornerRadius:7.0f];
    [self.mapView.layer setMasksToBounds:YES];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
