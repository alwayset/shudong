//
//  SDTabViewController.m
//  shudong
//
//  Created by admin on 14-4-26.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "SDTabViewController.h"

@interface SDTabViewController ()

@end

@implementation SDTabViewController

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
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, 55, 55);
    
    //UIImage * lips = [UIImage imageNamed:@"circleButtonImage.png"];
    
    [button setImage:[UIImage imageNamed:@"post.png"] forState:UIControlStateNormal];
    //[button setTitle:@"+" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:32.0/255.0 green:35.0/255.0 blue:44.0/255.0 alpha:1]];
    [button.layer setCornerRadius:button.frame.size.height / 2];
    [button.layer setBorderColor:[UIColor whiteColor].CGColor];
    [button.layer setBorderWidth:2.0f];
    
    //self.alpha = 0.8;
    
    //[button setBackgroundColor:[UIColor redColor]];
    //[button setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    //[button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = 60 - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0-5;
        button.center = center;
    }
    
    [self.view addSubview:button];

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
