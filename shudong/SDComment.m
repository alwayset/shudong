//
//  SDComment.m
//  shudong
//
//  Created by admin on 14-5-2.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "SDComment.h"

@implementation SDComment
@dynamic text;
@dynamic commenter;
@dynamic face;
+ (NSString *)parseClassName {
    return @"Comment";
}
@end
