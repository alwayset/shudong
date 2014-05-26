//
//  SDAddTerritoryViewController.h
//  shudong
//
//  Created by Eric Tao on 5/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SDAddTerritoryViewController : UIViewController<MKMapViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mainMap;

@end
