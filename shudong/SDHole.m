//
//  SDHole.m
//  shudong
//
//  Created by Eric Tao on 4/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDHole.h"



@implementation SDHole
@dynamic name, memberCount, postCount;
@dynamic posts;
//@dynamic depts, years;
@dynamic type;


+ (NSString *)parseClassName {
    return @"Hole";
}

@end
