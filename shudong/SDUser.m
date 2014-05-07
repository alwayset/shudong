//
//  SDUser.m
//  shudong
//
//  Created by Eric Tao on 4/30/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDUser.h"

@implementation SDUser


@dynamic memberOf;
@dynamic country, province, city;



+(NSString *)parseClassName {
    return @"_User";
}

@end
