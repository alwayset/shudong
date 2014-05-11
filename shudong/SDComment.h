//
//  SDComment.h
//  shudong
//
//  Created by admin on 14-5-2.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
@interface SDComment : AVObject <AVSubclassing>
@property (nonatomic, copy) NSString* text;
@property (nonatomic, retain) AVUser* commenter;
@property (nonatomic) int face;
@end
