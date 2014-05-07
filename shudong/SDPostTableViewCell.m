//
//  SDPostTableViewCell.m
//  shudong
//
//  Created by Eric Tao on 4/28/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDPostTableViewCell.h"
#import "SDUtils.h"
#import "Constants.h"

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
    [self.likeButton setText:(self.post.likeCount)? [self.post.likeCount stringValue]:@"0"];
    [self.commentButton setTitle:[@"  " stringByAppendingString:(self.post.commentCount)? [self.post.commentCount stringValue]:@"0"] forState:UIControlStateNormal];
    [self.likeButton initRedHeart:[[[SDUtils sharedInstance] myLikes] containsObject:self.post]];
}

-(void)showPictureWithData:(NSData *)data
{
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
    BOOL liked = false;
    for (SDPost* i in [[SDUtils sharedInstance] myLikes])
        if ([i.objectId isEqualToString:self.post.objectId]) {
            liked = true;break;
        }
    if ([[[SDUtils sharedInstance] myLikes] containsObject:self.post]) {
        [self.post incrementKey:@"likeCount" byAmount:[NSNumber numberWithInt:-1]];
        [[[SDUtils sharedInstance] myLikes] removeObject:self.post];
        [[self.post relationforKey:@"likedBy"] removeObject:[AVUser currentUser]];
        [self.likeButton setRedHeart:NO];
        
    } else {
        [self.post incrementKey:@"likeCount" byAmount:[NSNumber numberWithInt:1]];
        [[[SDUtils sharedInstance] myLikes] addObject:self.post];
        [[self.post relationforKey:@"likedBy"] addObject:[AVUser currentUser]];
        [self.likeButton setRedHeart:YES];
    }
    [self.likeButton setText:[self.post.likeCount stringValue]];
    [self.post saveEventually];
    if (self.indexPathInMain) [[NSNotificationCenter defaultCenter] postNotificationName:LikedAPostNotif object:self.indexPathInMain];
    
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
