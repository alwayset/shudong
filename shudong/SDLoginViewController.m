//
//  SDLoginViewController.m
//  shudong
//
//  Created by admin on 14-4-28.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "SDLoginViewController.h"
#import "Constants.h"
#import "SDUser.h"
#import <AVOSCloud/AVOSCloud.h>
#import <MBProgressHUD/MBProgressHUD.h>


@interface SDLoginViewController ()

@end

@implementation SDLoginViewController

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
    [RennClient initWithAppId:RR_APP_ID apiKey:RR_API_KEY secretKey:RR_SECRET];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginWithRenren:(id)sender {
    
    if ([RennClient isLogin]) {
        [RennClient logoutWithDelegate:self];
    }
    else {
        [RennClient loginWithDelegate:self];
    }
    
    
}

#pragma mark login

- (IBAction)Login:(id)sender {
    if ([RennClient isLogin]) {
        [RennClient logoutWithDelegate:self];
        [RennClient loginWithDelegate:self];
    }
    else {
        [RennClient loginWithDelegate:self];
    }
}

- (void)rennLoginSuccess
{
    [SDUtils log:@"人人登陆成功"];
    GetUserParam *param = [[GetUserParam alloc] init];
    param.userId = [RennClient uid];
    [RennClient sendAsynRequest:param delegate:self];
}

- (void)rennLogoutSuccess
{
    [SDUtils log:@"人人登陆成功"];

}

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    
    NSDictionary *degrees = @{@"DOCTOR": @0,
                              @"COLLEGE":@1,
                              @"GVY" : @2,
                              @"PRIMARY":@3,
                              @"OTHER":@4,
                              @"TEACHER":@5,
                              @"MASTER":@6,
                              @"HIGHSCHOOL":@7,
                              @"TECHNICAL":@8,
                              @"JUNIOR":@9,
                              @"SECRET": @10};
    
    
    
    
    //NSLog(@"requestSuccessWithResponse:%@", [response description]);
    NSLog(@"requestSuccessWithResponse:%@", [[SBJSON new]  stringWithObject:response error:nil]);
    NSLog(@"请求成功:%@", service.type);

    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"为你准备内容中";
    
    
    SDUser *newUser = [SDUser user];
    newUser.username = [NSString stringWithFormat:@"rr%@", response[@"id"]];
    newUser.password = @"shudongshudong";

    NSMutableArray *schools =  [NSMutableArray arrayWithArray:response[@"education"]];
    NSError *err;
    for (NSDictionary *eachSchoolRawData in schools) {
        AVQuery *holeQuery = [SDHole query];
        [holeQuery whereKey:@"name" equalTo:eachSchoolRawData[@"name"]];
        AVObject *existingHole = [holeQuery getFirstObject:&err];
        if (!err) {
            [[[AVUser currentUser] relationforKey:@"memberOf"] addObject:existingHole];
        } else {
            if (err.code == kAVErrorObjectNotFound) {
                SDHole *newHole = [SDHole object];
                newHole.name = eachSchoolRawData[@"name"];
                
            }
        }
    }
    
    
    
    

}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    //NSLog(@"requestFailWithError:%@", [error description]);
    NSString *domain = [error domain];
    NSString *code = [[error userInfo] objectForKey:@"code"];
    NSLog(@"requestFailWithError:Error Domain = %@, Error Code = %@", domain, code);
    NSLog(@"请求失败: %@", domain);
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
