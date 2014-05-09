//
//  SDDiscoverViewController.h
//  shudong
//
//  Created by admin on 14-5-8.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDDiscoverViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
