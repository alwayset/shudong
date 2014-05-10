//
//  SDSettingViewController.h
//  shudong
//
//  Created by admin on 14-5-10.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDSettingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
