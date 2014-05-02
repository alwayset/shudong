//
//  SDUtils.m
//  shudong
//
//  Created by Eric Tao on 4/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//


#import "Constants.h"

#import "SDUtils.h"
#import "SDHole.h"

static SDUtils *singletonInstance;


@interface SDUtils ()

@end


@implementation SDUtils
@synthesize myHoles;

//initialization


+ (void)initEverything {
    if (singletonInstance == nil) {
        singletonInstance = [[SDUtils alloc] init];
    }
}

- (void)loadMyHoles {
    
    //AVUser *currentUser = [AVUser currentUser];
    //AVQuery *holeQuery = [[currentUser relationforKey:@"memberOf"] query];
    AVQuery *holeQuery = [SDHole query];
    holeQuery.cachePolicy = kAVCachePolicyNetworkElseCache;
    [holeQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            myHoles = [NSArray arrayWithArray:results];
        } else {
            [SDUtils showErrALertWithText:@"载入失败"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:DidLoadMyHolesNotif object:nil];
    }];
}

+ (void)log:(NSString *)message {
    NSLog(message);
}

+ (SDUtils *)sharedInstance {
    return singletonInstance;
}


+(void)showErrALertWithText:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}
+ (NSString*)getTimeStr:(NSDate*) time {
    NSTimeInterval interval = -[time timeIntervalSinceNow];
    int minutes = interval/60;
    int hours = minutes/60;
    int days = hours/24;
    int months = days/30;
    int years = months/12;
    if (years>0) return [NSString stringWithFormat:@"%d年前",years];
    if (months>0) return [NSString stringWithFormat:@"%d个月前",months];
    if (days>0) return [NSString stringWithFormat:@"%d天前",days];
    if (hours>0) return [NSString stringWithFormat:@"%d小时前",hours];
    if (minutes>0) return [NSString stringWithFormat:@"%d分钟前",minutes];
    return @"刚刚";
}
+ (CGFloat)screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}
@end
