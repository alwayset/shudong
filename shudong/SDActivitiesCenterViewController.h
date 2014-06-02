//
//  SDActivitiesCenterViewController.h
//  shudong
//
//  Created by admin on 14-5-7.
//  Copyright (c) 2014年 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDActivitiesCenterViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *nothingTipView;
@property (nonatomic,retain) IBOutlet UILabel* nothingTipLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *filesInDownload;
@property (strong, nonatomic) UIRefreshControl *refresh;
@end
