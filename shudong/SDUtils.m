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
@synthesize parsedHoles;


@synthesize mySchools;



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
            [self parseHoles];
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

- (void)parseHoles {
    
    static char deptIdentifier = '^';
    static char yearIndentifier = '#';
    
    if (parsedHoles == nil) {
        parsedHoles = [[NSMutableDictionary alloc] init];
    }
    NSMutableArray *tempHoleArray = [NSMutableArray arrayWithArray:myHoles];
    
    mySchools = [[NSMutableArray alloc] init];
    
    
    
    for (SDHole *eachHole in myHoles) {
        if (eachHole.type) {
            
            eachHole.depts = [[NSMutableArray alloc] init];
            eachHole.years = [[NSMutableArray alloc] init];
            eachHole.yearsDepts = [[NSMutableArray alloc] init];
            
            [mySchools addObject:eachHole];
            [tempHoleArray removeObject:eachHole];
            
            for (SDHole *eachSubHole in tempHoleArray) {
                
                if ([eachSubHole.name hasPrefix:eachHole.name]) {
                    NSString *detailPart = [eachSubHole.name substringFromIndex:eachHole.name.length];
                    if ([detailPart characterAtIndex:0] == deptIdentifier) {
                        // dept or year&dept
                        if ([detailPart characterAtIndex:detailPart.length - 1] == yearIndentifier) {
                            // this is a year depts
                            detailPart = [detailPart stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", deptIdentifier] withString:@""];
                            detailPart = [detailPart stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", yearIndentifier] withString:@""];
                            [eachHole.yearsDepts addObject:detailPart];
                            
                        } else {
                            //dept only
                            
                            detailPart = [detailPart stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", deptIdentifier] withString:@""];
                            [eachHole.depts addObject:detailPart];
                        }
                        
                    } else if ([detailPart characterAtIndex:0] == yearIndentifier) {
                        NSString *yearName = [detailPart substringWithRange:NSMakeRange(1, detailPart.length - 2)];
                        [eachHole.years addObject:detailPart];
                        NSLog(@"parsed year is %@", yearName);
                    }
                    
                }
                
                
            }
            
            
            
            
            
//            if (parsedHoles[eachHole.type]) {
//                NSMutableArray *arr = parsedHoles[eachHole.type];
//                [arr addObject:eachHole];
//                parsedHoles[eachHole.type] = arr;
//            } else {
//                NSMutableArray *arr = [[NSMutableArray alloc] init];
//                [arr addObject:eachHole];
//                parsedHoles[eachHole.type] = arr;
//            }
        }
    }
    
    
    for (int holeType = 0; holeType < 5; holeType++) {
        NSMutableArray *schools = parsedHoles[[NSNumber numberWithInt:holeType]];
        if (schools) {
            for (SDHole *eachSchool in schools) {
                for (SDHole *eachOtherHole in tempHoleArray) {
                    if ([eachOtherHole.name hasPrefix:eachSchool.name]) {
                        if (parsedHoles[eachSchool.name]) {
                            NSMutableArray *subHoles = parsedHoles[eachSchool.name];
                            [subHoles addObject:eachOtherHole.name];
                            parsedHoles[eachSchool.name] = subHoles;
                        } else {
                            NSMutableArray *subHoles = [[NSMutableArray alloc] init];
                            [subHoles addObject:eachOtherHole.name];
                            parsedHoles[eachSchool.name] = subHoles;
                        }
                    }
                }
            }
        }
    }
    
    NSLog(@"the parsed data is: %@", parsedHoles);
}

@end
