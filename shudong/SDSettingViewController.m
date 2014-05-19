//
//  SDSettingViewController.m
//  shudong
//
//  Created by admin on 14-5-10.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import "SDSettingViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SDMainTableViewController.h"

@interface SDSettingViewController ()

@end

@implementation SDSettingViewController
@synthesize tableView;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0: return 4; break;
        case 1: return 2; break;
        case 2: return 1; break;
        default: break;
    }
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        [AVUser logOut];
        SDMainTableViewController *main = [self.tabBarController.viewControllers objectAtIndex:0];
        [self.tabBarController setSelectedViewController:main];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = @"邀请朋友";
                    break;
                }
                case 1: {
                    cell.textLabel.text = @"给我评分";
                    break;
                }
                case 2: {
                    cell.textLabel.text = @"意见反馈";
                    break;
                }
                case 3: {
                    cell.textLabel.text = @"Q&A";
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1: {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"检查更新";
            } else {
                cell.textLabel.text = @"清除痕迹";
            }
            break;
        }
        case 2: {
            cell.textLabel.text = @"注销";
            break;
        }
        default: break;
    }
    return cell;
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
