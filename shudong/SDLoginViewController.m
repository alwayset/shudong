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
    [SDUtils log:@"人人登出"];
    [RennClient loginWithDelegate:self];

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

    NSError *signupErr;
    [newUser signUp:&signupErr];
    if (!signupErr) {
    } else {
        if (signupErr.code == kAVErrorUsernameTaken) {
            NSError *loginErr;
            [AVUser logInWithUsername:newUser.username password:newUser.password error:&loginErr];
            if (!loginErr) {
                
            } else {
                NSLog(@"sign up error: %@", signupErr);
                [SDUtils showErrALertWithText:@"注册失败"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                return;
            }
        } else {
            NSLog(@"sign up error: %@", signupErr);
            [SDUtils showErrALertWithText:@"注册失败"];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return;
        }
    }

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
            if ([self isDeptValid:dept]) {
                
                NSError *deptErr;
                AVQuery *deptQuery = [[existingHole relationforKey:@"depts"] query];
                [deptQuery whereKey:@"name" equalTo:[NSString stringWithFormat:@"%@%@", schoolName, dept]];
                AVObject *existingDept = [deptQuery getFirstObject:&deptErr];
                if (!deptErr) {
                    [[existingHole relationforKey:@"depts"] addObject:existingDept];
                    [existingHole save];
                    [[newUser relationforKey:@"memberOf"] addObject:existingDept];
                    NSLog(@"找到已存在的%@%@", schoolName, dept);
                } else {
                    if (deptErr.code == kAVErrorObjectNotFound) {
                        SDHole *newDept = [SDHole object];
                        newDept.name = [NSString stringWithFormat:@"%@%@", schoolName, dept];
                        newDept.memberCount = @0;
                        [newDept incrementKey:@"memberCount"];
                        newDept.postCount = @0;
                        [newDept save];
                        [[existingHole relationforKey:@"depts"] addObject:newDept];
                        [existingHole save];
                        [[newUser relationforKey:@"memberOf"] addObject:newDept];
                        NSLog(@"创建新的%@%@", schoolName, dept);
                    }  else {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [SDUtils showErrALertWithText:@"注册失败,请检查网络"];
                        return;
                    }
                }
            }

            NSLog(@"year:%@", year);
            if (year.class != [NSNull class]) {
                
                NSError *yearErr;
                AVQuery *yearQuery = [[existingHole relationforKey:@"years"] query];
                [yearQuery whereKey:@"name" equalTo:[NSString stringWithFormat:@"%@%@%@级", schoolName, degrees[degree], [year substringFromIndex:2]]];
                AVObject *existingYear = [yearQuery getFirstObject:&yearErr];
                if (!yearErr) {
                    [[existingHole relationforKey:@"years"] addObject:existingYear];
                    [existingHole save];
                    [[newUser relationforKey:@"memberOf"] addObject:existingYear];
                    NSLog(@"找到已存在的%@%@", schoolName, year);
                } else {
                    if (yearErr.code == kAVErrorObjectNotFound) {
                        SDHole *newYear = [SDHole object];
                        newYear.name = [NSString stringWithFormat:@"%@%@%@级", schoolName, degrees[degree], [year substringFromIndex:2]];
                        newYear.memberCount = @0;
                        [newYear incrementKey:@"memberCount"];
                        newYear.postCount = @0;
                        [newYear save];
                        [[existingHole relationforKey:@"years"] addObject:newYear];
                        [existingHole save];
                        [[newUser relationforKey:@"memberOf"] addObject:newYear];
                        NSLog(@"创建新的%@%@", schoolName, year);
                    } else {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [SDUtils showErrALertWithText:@"注册失败,请检查网络"];
                        return;
                    }
                }
            }
            
            NSLog(@"year:%@; dept %@", year, dept);
            if (year.class != [NSNull class] && [self isDeptValid:dept]) {
                
                NSError *yearDeptErr;
                AVQuery *yearDeptQuery = [[existingHole relationforKey:@"yearDept"] query];
                [yearDeptQuery whereKey:@"name" equalTo:[NSString stringWithFormat:@"%@%@%@%@级", schoolName, dept, degrees[degree], [year substringFromIndex:2]]];
                AVObject *existingYearDept = [yearDeptQuery getFirstObject:&yearDeptErr];
                if (!yearDeptErr) {
                    [[existingHole relationforKey:@"yearDept"] addObject:existingYearDept];
                    [existingHole save];
                    [[newUser relationforKey:@"memberOf"] addObject:existingYearDept];
                    NSLog(@"找到已存在的%@%@", schoolName, year);
                } else {
                    if (yearDeptErr.code == kAVErrorObjectNotFound) {
                        SDHole *newYearDept = [SDHole object];
                        newYearDept.name = [NSString stringWithFormat:@"%@%@%@%@届", schoolName, dept, degrees[degree], [year substringFromIndex:2]];
                        newYearDept.memberCount = @1;
                        newYearDept.postCount = @0;
                        [newYearDept save];
                        [[existingHole relationforKey:@"yearDept"] addObject:newYearDept];
                        [existingHole save];
                        [[newUser relationforKey:@"memberOf"] addObject:newYearDept];
                        NSLog(@"创建新的%@%@%@", schoolName, dept, year);
                    } else {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [SDUtils showErrALertWithText:@"注册失败,请检查网络"];
                        return;
                    }
                }
            }
        } else {
            if (err.code == kAVErrorObjectNotFound) {
                
                SDHole *newSchool = [SDHole object];
                newSchool.name = schoolName;
                newSchool.memberCount = @0;
                newSchool.postCount = @0;
                [newSchool incrementKey:@"memberCount"];
                [newSchool save];
                [[[AVUser currentUser] relationforKey:@"memberOf"] addObject:newSchool];
                NSLog(@"创建新的%@", schoolName);
                
                if (dept.class != [NSNull class] && [self isDeptValid:dept]) {
                    SDHole *newDept = [SDHole object];
                    newDept.name = [NSString stringWithFormat:@"%@%@", schoolName, dept];
                    newDept.memberCount = @0;
                    [newDept incrementKey:@"memberCount"];
                    newDept.postCount = @0;
                    [newDept save];
                    [[newSchool relationforKey:@"depts"] addObject:newDept];
                    [[newUser relationforKey:@"memberOf"] addObject:newDept];
                    NSLog(@"创建新的%@%@", schoolName, dept);
                }

                if (year.class != [NSNull class]) {
                    SDHole *newYear = [SDHole object];
                    newYear.name = [NSString stringWithFormat:@"%@%@%@级", schoolName, degrees[degree], [year substringFromIndex:2]];
                    newYear.memberCount = @0;
                    [newYear incrementKey:@"memberCount"];
                    newYear.postCount = @0;
                    [newYear save];
                    [[newSchool relationforKey:@"years"] addObject:newYear];
                    [[newUser relationforKey:@"memberOf"] addObject:newYear];
                    NSLog(@"创建新的%@%@", schoolName, year);
                }
                
                if (year.class != [NSNull class] && [self isDeptValid:dept]) {
                    
                    SDHole *newYearDept = [SDHole object];
                    newYearDept.name = [NSString stringWithFormat:@"%@%@%@%@级", schoolName, dept, degrees[degree], [year substringFromIndex:2]];
                    newYearDept.memberCount = @0;
                    [newYearDept incrementKey:@"memberCount"];
                    newYearDept.postCount = @0;
                    [newYearDept save];
                    [[newSchool relationforKey:@"yearDept"] addObject:newYearDept];
                    [[newUser relationforKey:@"memberOf"] addObject:newYearDept];
                }
                
                [newSchool save];
                [[AVUser currentUser] save];

            } else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [SDUtils showErrALertWithText:@"注册失败,请检查网络"];
                return;
            }
        }
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];


}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    //NSLog(@"requestFailWithError:%@", [error description]);
    NSString *domain = [error domain];
    NSString *code = [[error userInfo] objectForKey:@"code"];
    NSLog(@"requestFailWithError:Error Domain = %@, Error Code = %@", domain, code);
    NSLog(@"请求失败: %@", domain);
}

- (BOOL)isDeptValid:(NSString *)dept {
    
    if (dept.class != [NSNull class] && ![dept isEqualToString:@"其它院系"]) {
        return YES;
    } else {
        return NO;
    }
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
