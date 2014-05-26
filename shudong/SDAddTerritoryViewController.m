//
//  SDAddTerritoryViewController.m
//  shudong
//
//  Created by Eric Tao on 5/26/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDAddTerritoryViewController.h"
#import "SDTerrAnno.h"
#import "SDUtils.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Constants.h"

@interface SDAddTerritoryViewController ()
@property SDTerrAnno *selectedPin;
@property MKCircle *selectedCircle;
@property MKCircle *userLocCircle;

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
    self.navigationController.navigationBarHidden = NO;
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
    
    if (self.userLocCircle) {
        [self.mainMap removeOverlay:self.userLocCircle];
    }
    self.userLocCircle = [MKCircle circleWithCenterCoordinate:userLocation.coordinate radius:500];
    [self.mainMap addOverlay:self.userLocCircle];
    if (self.selectedCircle) {
        [self.mainMap addOverlay:self.selectedCircle];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    if (overlay == self.userLocCircle) {
        MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
        circleView.strokeColor = [UIColor lightGrayColor];
        circleView.fillColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.65];
        return circleView;
    } else {
        
        MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
        circleView.strokeColor = [UIColor orangeColor];
        circleView.fillColor = [[UIColor orangeColor] colorWithAlphaComponent:0.45];
        return circleView;
    }
    return nil;
    

}

- (IBAction)mapTapped:(UIGestureRecognizer *)gestureRecognizer
{
//    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
//        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mainMap];
    CLLocationCoordinate2D touchMapCoordinate = [self.mainMap convertPoint:touchPoint toCoordinateFromView:self.mainMap];
    
    CLLocation *selectedLocation = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    CLLocationDistance distance = [selectedLocation distanceFromLocation:self.mainMap.userLocation.location];
    if (distance > 500) {
        [SDUtils showErrALertWithText:@"领地的中心必须在你所在范围之内"];
        return;
    }
    
    SDTerrAnno *annot = [[SDTerrAnno alloc] initWithCoords:touchMapCoordinate];
    [self.mainMap removeAnnotation:self.selectedPin];
    self.selectedPin = annot;
    [self.mainMap addAnnotation:self.selectedPin];
    if (self.selectedCircle) {
        [self.mainMap removeOverlay:self.selectedCircle];
    }
    self.selectedCircle = [MKCircle circleWithCenterCoordinate:touchMapCoordinate radius:500.0];
    [self.mainMap addOverlay:self.selectedCircle];
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

- (IBAction)askForName:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入领地的名字" message:@"请保证8个字以内" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *name = [alertView textFieldAtIndex:0].text;
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([self convertToInt:name] > 20) {
            [SDUtils showErrALertWithText:@"领地名字太长"];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"创建领地中";
            
            
            AVObject *newTerr = [AVObject objectWithClassName:@"Terr"];
            newTerr[@"location"] = [AVGeoPoint geoPointWithLatitude:self.selectedPin.coordinate.latitude longitude:self.selectedPin.coordinate.longitude];
            newTerr[@"name"] = name;
            newTerr[@"roarCount"] = @0;
            [newTerr saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        //do nothing;
                        [[NSNotificationCenter defaultCenter] postNotificationName:ShouldLoadCurrentTerrNotif object:nil];
                    }];
                    [hud hide:YES afterDelay:0.5];
                } else {
                    [SDUtils showErrALertWithText:[NSString stringWithFormat:@"无法创建%@", name]];
                }
            }];
            
            
        }
    }
}


-  (int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
    
}


-(IBAction)dismissSelf:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
