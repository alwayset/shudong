//
//  SDPost.h
//  shudong
//
//  Created by Eric Tao on 4/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "SDHole.h"

@interface SDPost : AVObject <AVSubclassing>

@property (nonatomic, copy) NSString *text;
@property (nonatomic) AVFile *image;
@property (nonatomic) AVUser *poster;
@property (nonatomic) NSNumber *likeCount;
@property (nonatomic) NSNumber *commentCount;
@property (nonatomic) NSNumber *picId;
@property (nonatomic) AVRelation *holes;
@property (nonatomic) AVRelation *comments;
@property (nonatomic,strong) NSMutableArray* commentsArr;

@property (nonatomic, copy) SDHole *cat1; //university
@property (nonatomic, copy) SDHole *cat2; //gaozhong
@property (nonatomic, copy) SDHole *cat3; //chuzhong
@property (nonatomic, copy) SDHole *cat4; //xiaoxue
@property (nonatomic, copy) SDHole *cat5; //dazhuan
@property (nonatomic, copy) SDHole *cat6; //zhongzhuan


@end
