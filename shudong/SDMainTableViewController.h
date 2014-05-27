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
@interface SDMainTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate> {
    
    
}


@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UITableView *categoryTV;
@property (strong, nonatomic) IBOutlet UIView *categoryView;
@property (nonatomic) int selectedRow;


@end
