//
//  SDAppDelegate.h
//  shudong
//
//  Created by Eric Tao on 4/25/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDAppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController *_navigationController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigationController;
@end
