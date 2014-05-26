//
//  SDTerrAnno.m
//  shudong
//
//  Created by Eric Tao on 5/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDTerrAnno.h"

@implementation SDTerrAnno

@synthesize coordinate;

- (id) initWithCoords:(CLLocationCoordinate2D) coords{
    
    self = [super init];
    if (self != nil) {
        coordinate = coords;
    }
    
    
    return self;
}


@end
