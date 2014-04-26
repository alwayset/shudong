//
//  SDMainTableViewController.h
//  shudong
//
//  Created by Eric Tao on 4/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import "SDUtils.h"

@interface SDMainTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) IBOutlet UITableView *tableview;

@end
