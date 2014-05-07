//
//  SDUser.h
//  shudong
//
//  Created by Eric Tao on 4/30/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "SDHole.h"

@interface SDUser : AVUser<AVSubclassing>

//@property (nonatomic) SDHole *cat1; //university
//@property (nonatomic) SDHole *cat1a; //同届
//@property (nonatomic) SDHole *cat1b; //同院系
//@property (nonatomic) SDHole *cat1c; //同院 同届
//
//
//@property (nonatomic) SDHole *cat2; //gaozhong
//@property (nonatomic) SDHole *cat2a; //same
//
//
//@property (nonatomic) SDHole *cat3; //chuzhong
//@property (nonatomic) SDHole *cat4; //xiaoxue
//@property (nonatomic) SDHole *cat5; //dazhuan
//@property (nonatomic) SDHole *cat6; //zhongzhuan

@property (nonatomic) AVRelation *memberOf;

//location
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;

//name
@property (nonatomic, copy) NSString *name;

@end
