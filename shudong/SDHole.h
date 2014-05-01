//
//  SDHole.h
//  shudong
//
//  Created by Eric Tao on 4/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface SDHole : AVObject <AVSubclassing>
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSNumber *memberCount;
@property (nonatomic) NSNumber *postCount;
@property (nonatomic) AVRelation *posts;
@property (nonatomic) NSArray *depts;
@property (nonatomic) NSArray *years;


@end
