//
//  SDChooseHoleTableViewController.h
//  shudong
//
//  Created by Eric Tao on 4/29/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ChooseHoleDelegate

- (void)didFinishChoosingHoles:(NSArray *)targetHoles;

@end

@interface SDChooseHoleTableViewController : UITableViewController


@end
