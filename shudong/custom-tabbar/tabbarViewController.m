//
//  tabbarViewController.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "tabbarViewController.h"
#import "tabbarView.h"
#import "SDMainTableViewController.h"
#import "SDAddPostViewController.h"
#import "Constants.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface tabbarViewController ()

@end

@implementation tabbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabbar) name:ShouldShowTabbarNotif object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTabbar) name:ShouldHideTabbarNotif object:nil];

    
    
	// Do any additional setup after loading the view, typically from a nib.
    CGFloat orginHeight = self.view.frame.size.height- 60;
    if (iPhone5) {
//        orginHeight = self.view.frame.size.height- 60 + addHeight;
        orginHeight = self.view.frame.size.height- 60;
    }
    _tabbar = [[tabbarView alloc]initWithFrame:CGRectMake(0,  orginHeight, 320, 60)];
    _tabbar.delegate = self;
    [self.view addSubview:_tabbar];
    
    _arrayViewcontrollers = [self getViewcontrollers];
    [self touchBtnAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchBtnAtIndex:(NSInteger)index

{
    
    if (index == 10) { //button-center is presed
        
        SDAddPostViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addpost"];
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    
    
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    

    NSDictionary* data = [_arrayViewcontrollers objectAtIndex:index];
    
    UIViewController *viewController = data[@"viewController"];
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height- 50);
    
    [self.view insertSubview:viewController.view belowSubview:_tabbar];

}

-(NSArray *)getViewcontrollers
{
    NSArray* tabBarItems = nil;
    
    
    
    
    SDMainTableViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"main"];
    
    
    tabBarItems = [NSArray arrayWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", mainVC, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", mainVC, @"viewController",@"主页",@"title", nil],nil];
    
    return tabBarItems;
    
}

- (void)hideTabbar {
    
    [UIView animateWithDuration:0.3 animations:^{
        _tabbar.alpha = 0;
    }];
}

- (void)showTabbar {
    [UIView animateWithDuration:0.3 animations:^{
        _tabbar.alpha = 1;
    }];
}

@end
