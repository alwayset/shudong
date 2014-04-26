//
//  SDUtils.h
//  shudong
//
//  Created by Eric Tao on 4/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>






@interface SDUtils : NSObject



@property (nonatomic, strong) NSArray *myHoles;

//methods
+ (void)initEverything;




+ (void)showErrALertWithText:(NSString *)message;
+ (SDUtils *)sharedInstance;

- (void)loadMyHoles;

@end
