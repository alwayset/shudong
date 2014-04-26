//
//  SDPost.h
//  shudong
//
//  Created by Eric Tao on 4/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface SDPost : AVObject <AVSubclassing>

@property (nonatomic, copy) NSString *text;
@property (nonatomic) AVFile *image;
@property (nonatomic) AVUser *poster;
@property (nonatomic) NSNumber *likeCount;
@property (nonatomic) NSNumber *commentCount;
@property (nonatomic) NSArray *holes;

@end
