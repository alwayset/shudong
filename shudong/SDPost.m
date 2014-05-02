//
//  SDPost.m
//  shudong
//
//  Created by Eric Tao on 4/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDPost.h"


@implementation SDPost

@dynamic text, image, poster;
@dynamic likeCount, commentCount;
@dynamic holes,comments;
@dynamic picId;
@synthesize commentsArr;
//@dynamic cat1, cat2, cat3, cat4, cat5, cat6;

+ (NSString *)parseClassName {
    return @"Post";
}

@end
