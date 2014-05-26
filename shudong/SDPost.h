//
//  SDPost.h
//  shudong
//
//  Created by Eric Tao on 4/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "SDPost.h"

@interface SDPost : AVObject <AVSubclassing>

@property (nonatomic, copy) NSString *text;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic) AVFile *image;
@property (nonatomic) AVUser *poster;
@property (nonatomic) NSNumber *likeCount;
@property (nonatomic) NSNumber *commentCount;
@property (nonatomic) NSNumber *score;

@property (nonatomic) AVGeoPoint *location;
@property (nonatomic) NSString *displayName;
@property (nonatomic) AVRelation *comments;
@property (nonatomic,strong) NSMutableArray* commentsArr;
@property (nonatomic) AVObject *terr;

//@property (nonatomic, copy) SDHole *cat1; //university
//@property (nonatomic, copy) SDHole *cat2; //gaozhong
//@property (nonatomic, copy) SDHole *cat3; //chuzhong
//@property (nonatomic, copy) SDHole *cat4; //xiaoxue
//@property (nonatomic, copy) SDHole *cat5; //dazhuan
//@property (nonatomic, copy) SDHole *cat6; //zhongzhuan





@end
