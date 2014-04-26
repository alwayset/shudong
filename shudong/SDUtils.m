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
    
    AVUser *currentUser = [AVUser currentUser];
    AVQuery *holeQuery = [AVRelation reverseQuery:@"Hole" relationKey:@"members" childObject:currentUser];
    holeQuery.cachePolicy = kAVCachePolicyCacheThenNetwork;
    [holeQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            
            myHoles = [NSArray arrayWithArray:results];
            
            
        } else {
            [SDUtils showErrALertWithText:@"载入失败"];
        }
        
    }];
    
    
    
}








+ (SDUtils *)sharedInstance {
    return singletonInstance;
}


+(void)showErrALertWithText:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}

@end
