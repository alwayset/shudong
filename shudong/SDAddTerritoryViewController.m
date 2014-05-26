//
//  SDAddTerritoryViewController.m
//  shudong
//
//  Created by Eric Tao on 5/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDAddTerritoryViewController.h"
#import "SDTerrAnno.h"

@interface SDAddTerritoryViewController ()
@property SDTerrAnno *selectedPin;

@end

@implementation SDAddTerritoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.02;
    mapRegion.span.longitudeDelta = 0.02;
    
    [mapView setRegion:mapRegion animated: YES];
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:userLocation.coordinate radius:500];
    [self.mainMap removeOverlays:self.mainMap.overlays];
    [self.mainMap addOverlay:circle];
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor orangeColor];
    circleView.fillColor = [[UIColor orangeColor] colorWithAlphaComponent:0.25];
    return circleView;
}

- (IBAction)mapTapped:(UIGestureRecognizer *)gestureRecognizer
{
//    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
//        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mainMap];
    CLLocationCoordinate2D touchMapCoordinate = [self.mainMap convertPoint:touchPoint toCoordinateFromView:self.mainMap];
    SDTerrAnno *annot = [[SDTerrAnno alloc] initWithCoords:touchMapCoordinate];
    [self.mainMap removeAnnotation:self.selectedPin];
    self.selectedPin = annot;
    [self.mainMap addAnnotation:self.selectedPin];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if (annotation == self.selectedPin) {
        MKPinAnnotationView *annoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        [annoView setTintColor:[UIColor orangeColor]];
        [annoView setAnimatesDrop:YES];
        return annoView;
    }
    
    return nil;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
