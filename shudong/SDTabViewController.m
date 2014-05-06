//
//  SDTabViewController.m
//  shudong
//
//  Created by admin on 14-4-26.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "SDTabViewController.h"
#import "SDAddPostViewController.h"
#import <AVOSCloud/AVOSCloud.h>
@interface SDTabViewController ()
@end

@implementation SDTabViewController
@synthesize button;
@synthesize nav;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

        nav = [[UINavigationController alloc] init];
        nav.delegate = self;
//        [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    }
    return self;
}



- (void)addPostButton {
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, 55, 55);
    
    
    [button setImage:[UIImage imageNamed:@"post.png"] forState:UIControlStateNormal];
    //[button setTitle:@"+" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:32.0/255.0 green:35.0/255.0 blue:44.0/255.0 alpha:1]];
    [button.layer setCornerRadius:button.frame.size.height / 2];
    [button.layer setBorderColor:[UIColor whiteColor].CGColor];
    [button.layer setBorderWidth:1.0f];
    
    
    [button addTarget:self action:@selector(addPost) forControlEvents:UIControlEventTouchUpInside];
    
    
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addPostButton];
    
    // Do any additional setup after loading the view.
    

    
    //if (![AVUser currentUser]) {
    //    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SDLoginViewController"];
    //    [self.navigationController presentViewController:vc animated:YES completion:nil];
    //}
    //[self setHidesBottomBarWhenPushed:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addPostButton];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideButton:(BOOL)hide
{
    if (hide) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             [button setAlpha:0];
                         } completion:^(BOOL finished) {
                             [button removeFromSuperview];
                         }];
    } else {
        [self.view addSubview:button];
        [UIView animateWithDuration:0.2
                         animations:^{
                             [button setAlpha:1];
                         }];
    }
    
}

- (void)addPost {
    SDAddPostViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addpost"];
    [self presentViewController:vc animated:YES completion:nil];
}



-(void)setViewControllers:(NSArray *)viewControllers {
    [super setViewControllers:viewControllers];
    [self addPostButton];
}

-(void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:viewControllers animated:animated];
     [self addPostButton];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake( 94.0f, 0.0f, 131.0f, self.tabBar.bounds.size.height);
    [cameraButton setImage:[UIImage imageNamed:@"circleButtonImage.png"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"ButtonCameraSelected.png"] forState:UIControlStateHighlighted];
    [cameraButton addTarget:self action:@selector(addPost) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:cameraButton];
    
    
//    UISwipeGestureRecognizer *swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    [swipeUpGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
//    [swipeUpGestureRecognizer setNumberOfTouchesRequired:1];
//    [cameraButton addGestureRecognizer:swipeUpGestureRecognizer];
    
//    [self.tabBar addSubview:cameraButton];
    
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    button.frame = CGRectMake(0.0, 0.0, 55, 55);
//    
//    //UIImage * lips = [UIImage imageNamed:@"circleButtonImage.png"];
//    
//    [button setImage:[UIImage imageNamed:@"post.png"] forState:UIControlStateNormal];
//    //[button setTitle:@"+" forState:UIControlStateNormal];
//    [button setBackgroundColor:[UIColor colorWithRed:32.0/255.0 green:35.0/255.0 blue:44.0/255.0 alpha:1]];
//    [button.layer setCornerRadius:button.frame.size.height / 2];
//    [button.layer setBorderColor:[UIColor whiteColor].CGColor];
//    [button.layer setBorderWidth:1.0f];
//    
//    
//    [button addTarget:self action:@selector(addPost) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    CGFloat heightDifference = 60 - self.tabBar.frame.size.height;
//    if (heightDifference < 0)
//        button.center = self.tabBar.center;
//    else
//    {
//        CGPoint center = self.tabBar.center;
//        center.y = center.y - heightDifference/2.0-5;
//        button.center = center;
//    }
//    
//    [self.tabBar addSubview:button];
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
