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
#import "SDPost.h"
#import "SDAddPostViewController.h"
@interface SDMainTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, AddPostDelegate>


@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic) int selectedRow;
@end
