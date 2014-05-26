//
//  SDTerrTableViewCell.h
//  shudong
//
//  Created by Eric Tao on 5/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SDTerrTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *terrName;
@property (weak, nonatomic) IBOutlet UILabel *terrInfo;
@property (weak, nonatomic) IBOutlet MKMapView *terrLocMap;

@end
