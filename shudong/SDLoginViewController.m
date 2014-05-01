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
    
    NSDictionary *degrees = @{@"DOCTOR": @"博士",
                              @"COLLEGE":@"本科",
                              @"GVY" : @"校工",
                              @"PRIMARY":@"小学",
                              @"OTHER":@"其他",
                              @"TEACHER":@"教师",
                              @"MASTER":@"硕士",
                              @"HIGHSCHOOL":@"高中",
                              @"TECHNICAL":@"中专技校",
                              @"JUNIOR":@"初中",
                              @"SECRET": @"保密"};
    
    
    
    
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
        
        NSString *schoolName = eachSchoolRawData[@"name"];
        NSString *dept = eachSchoolRawData[@"department"];
        NSString *degree = eachSchoolRawData[@"educationBackground"];
        NSString *year = eachSchoolRawData[@"year"];
        
        
        
        AVQuery *holeQuery = [SDHole query];
        [holeQuery whereKey:@"name" equalTo:schoolName];
        AVObject *existingHole = [holeQuery getFirstObject:&err];
        if (!err) {
            [[newUser relationforKey:@"memberOf"] addObject:existingHole];
            NSLog(@"找到已存在的%@", schoolName);
            NSLog(@"dept:%@", dept);
            if (dept != nil) {
                
                NSError *deptsErr;
                AVQuery *deptsQuery = [[existingHole relationforKey:@"depts"] query];
                NSArray *existingDepts = [deptsQuery findObjects:&deptsErr];
                if (!deptsErr) {
                    
                    BOOL foundDept = NO;
                    
                    for (SDHole *eachDept in existingDepts) {
                        if ([eachDept.name isEqualToString:[NSString stringWithFormat:@"%@%@", schoolName, dept]]) {
                            [[newUser relationforKey:@"memberOf"] addObject:eachDept];
                            foundDept = YES;
                            continue;
                        }
                    }
                    
                    if (!foundDept) {
                        SDHole *newDept = [SDHole object];
                        newDept.name = [NSString stringWithFormat:@"%@%@", schoolName, dept];
                        newDept.memberCount = @0;
                        newDept.postCount = @0;
                        [newDept save];
                        [[existingHole relationforKey:@"depts"] addObject:newDept];
                        [existingHole save];
                        [[newUser relationforKey:@"memberOf"] addObject:newDept];
                        NSLog(@"创建新的%@%@", schoolName, dept);
                    } else {
                        NSLog(@"找到已存在的%@%@", schoolName, dept);
                    }
                    
                } else {
                    [SDUtils showErrALertWithText:@"注册失败,请检查网络"];
                    return;
                }
            }
            
            NSLog(@"year:%@", year);
            if (year != nil) {
                
                NSError *yearsErr;
                AVQuery *yearsQuery = [[existingHole relationforKey:@"years"] query];
                NSArray *existingYears = [yearsQuery findObjects:&yearsErr];
                if (!yearsErr) {
                    
                    BOOL foundYear = NO;
                    
                    for (SDHole *eachYear in existingYears) {
                        if ([eachYear.name isEqualToString:[NSString stringWithFormat:@"%@%@%@届", schoolName, degrees[degree], [year substringFromIndex:2] ]]) {
                            [[newUser relationforKey:@"memberOf"] addObject:eachYear];
                            foundYear = YES;
                            continue;
                        }
                    }
                    
                    if (!foundYear) {
                        SDHole *newYear = [SDHole object];
                        newYear.name = [NSString stringWithFormat:@"%@%@%@届", schoolName, degrees[degree], [year substringFromIndex:2]];
                        newYear.memberCount = @0;
                        newYear.postCount = @0;
                        [newYear save];
                        [[existingHole relationforKey:@"years"] addObject:newYear];
                        [existingHole save];
                        [[newUser relationforKey:@"memberOf"] addObject:newYear];
                        NSLog(@"创建新的%@%@", schoolName, year);
                    } else {
                        NSLog(@"找到已存在的%@%@", schoolName, year);
                    }
                    
                } else {
                    [SDUtils showErrALertWithText:@"注册失败,请检查网络"];
                    return;
                }
            }
            
            
        } else {
            if (err.code == kAVErrorObjectNotFound) {
                
                
                
                SDHole *newSchool = [SDHole object];
                newSchool.name = schoolName;
                newSchool.memberCount = @0;
                newSchool.postCount = @0;
                [newSchool save];
                [[[AVUser currentUser] relationforKey:@"memberOf"] addObject:newSchool];
                NSLog(@"创建新的%@", schoolName);
                
                if (!dept) {
                    SDHole *newDept = [SDHole object];
                    newDept.name = [NSString stringWithFormat:@"%@%@", schoolName, dept];
                    newDept.memberCount = @0;
                    newDept.postCount = @0;
                    [newDept save];
                    [[newSchool relationforKey:@"depts"] addObject:newDept];
                    [[newUser relationforKey:@"memberOf"] addObject:newDept];
                    NSLog(@"创建新的%@%@", schoolName, dept);
                }
                
                if (!year) {
                    SDHole *newYear = [SDHole object];
                    newYear.name = [NSString stringWithFormat:@"%@%@%@届", schoolName, degrees[degree], [year substringFromIndex:2]];
                    newYear.memberCount = @0;
                    newYear.postCount = @0;
                    [newYear save];
                    [[newSchool relationforKey:@"years"] addObject:newYear];
                    [[newUser relationforKey:@"memberOf"] addObject:newYear];
                    NSLog(@"创建新的%@%@", schoolName, year);
                }
                
                if (!year && !dept) {
                    
                    
                    SDHole *newYearDept = [SDHole object];
                    newYearDept.name = [NSString stringWithFormat:@"%@%@%@%@届", schoolName, dept, degrees[degree], [year substringFromIndex:2]];
                    newYearDept.memberCount = @0;
                    newYearDept.postCount = @0;
                    [newYearDept save];
                    [[newSchool relationforKey:@"years"] addObject:newYearDept];
                    [[newUser relationforKey:@"memberOf"] addObject:newYearDept];
                    
                }
                
                [newSchool save];
                
                
                
            } else {
                [SDUtils showErrALertWithText:@"注册失败,请检查网络"];
                return;
            }
        }
    }
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSError *signupErr;
    [newUser signUp:&signupErr];
    if ([AVUser currentUser]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"sign up error: %@", signupErr);
        [SDUtils showErrALertWithText:@"注册失败"];
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
