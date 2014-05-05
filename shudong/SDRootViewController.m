//
//  SDRootViewController.m
//  shudong
//
//  Created by Eric Tao on 5/4/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDRootViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SDLoginViewController.h"
#import "SDTabViewController.h"

@interface SDRootViewController ()

@end

@implementation SDRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (![AVUser currentUser]) {
        SDLoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:vc animated:NO completion:^{
            //do nothing for now
        }];
    } else {
//        if (firstLoad) {
//            [self loadPosts];
//        } else {
//        }
        
        
        SDTabViewController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"tab"];
        [self presentViewController:tab animated:NO completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
