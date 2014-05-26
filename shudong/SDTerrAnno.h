//
//  SDTerrAnno.h
//  shudong
//
//  Created by Eric Tao on 5/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SDTerrAnno : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


- (id) initWithCoords:(CLLocationCoordinate2D) coords;
@end
