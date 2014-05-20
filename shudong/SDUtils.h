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
@property (nonatomic, strong) NSMutableDictionary *parsedHoles;

@property (nonatomic, strong) NSMutableArray *mySchools;


@property (nonatomic, strong) NSMutableArray *myLikes;
@property (nonatomic, strong) NSMutableArray *newsArr;
@property (nonatomic, strong) NSMutableArray *postsArr;
@property (nonatomic, strong) NSMutableArray *newsPostArr;
@property (nonatomic, strong) NSMutableArray *subscribeArr;
@property (nonatomic, strong) NSMutableDictionary *newsDict;
@property (nonatomic, strong) NSMutableArray *mySubsObjectIds;

@property BOOL newsArrInitialized;
@property BOOL postsArrInitialized;
@property BOOL likesArrInitialized;
//methods
+ (void)initEverything;




+ (void)showErrALertWithText:(NSString *)message;
+ (SDUtils *)sharedInstance;

- (void)loadMyHoles;
- (void)loadPosts;
- (void)loadNewsArr; 
- (void)updateNewsDict;

+ (void)log:(NSString *)message;
+ (NSString*)getTimeStr:(NSDate*) time;
+ (CGFloat)screenHeight;
@end
