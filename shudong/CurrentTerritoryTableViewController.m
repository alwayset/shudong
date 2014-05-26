//
//  CurrentTerritoryTableViewController.m
//  
//
//  Created by Eric Tao on 5/26/14.
//
//

#import "CurrentTerritoryTableViewController.h"
#import <AVOSCloud/AVLocationManager.h>
#import <AVOSCloud/AVOSCloud.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "SDTerrTableViewCell.h"
#import <MapKit/MapKit.h>
#import "SDTerrAnno.h"
#import "Constants.h"
#import "SDAddTerritoryViewController.h"

@interface CurrentTerritoryTableViewController () {
    UIRefreshControl *refresh;
}

@end

@implementation CurrentTerritoryTableViewController
@synthesize dataSource;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(loadCurrentTerri) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCurrentTerri) name:ShouldLoadCurrentTerrNotif object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ([AVLocationManager sharedInstance].lastLocation) {
        [self loadCurrentTerri];
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"获取位置中";
        
        [[AVLocationManager sharedInstance] updateWithBlock:^(AVGeoPoint *geoPoint, NSError *error) {
            [hud hide:YES];
            if (!error) {
                [self loadCurrentTerri];
            }
        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return dataSource.count;
}

- (IBAction)loadCurrentTerri {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"载入领地中";
    
    AVGeoPoint *loc = [AVGeoPoint geoPointWithLocation:[AVLocationManager sharedInstance].lastLocation];
    AVQuery *terriQuery = [AVQuery queryWithClassName:@"Terr"];
    [terriQuery whereKey:@"location" nearGeoPoint:loc withinKilometers:1.5];
    [terriQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [refresh endRefreshing];
        [hud hide:YES];
        if (!error) {
            dataSource = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        } else {
            
        }
    }];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDTerrTableViewCell *cell = (SDTerrTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"terri" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.terrName.text = dataSource[indexPath.row][@"name"];
    NSNumber *roarCount = dataSource[indexPath.row][@"roarCount"];
    cell.terrInfo.text = [NSString stringWithFormat:@"%@声吼", roarCount];
    AVGeoPoint *loc = dataSource[indexPath.row][@"location"];
    SDTerrAnno *anno = [[SDTerrAnno alloc] initWithCoords:CLLocationCoordinate2DMake(loc.latitude, loc.longitude)];
    [cell.terrLocMap removeAnnotations:cell.terrLocMap.annotations];
    [cell.terrLocMap addAnnotation:anno];
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = anno.coordinate;
    mapRegion.span.latitudeDelta = 0.001;
    mapRegion.span.longitudeDelta = 0.001;
    
    [cell.terrLocMap setRegion:mapRegion animated: YES];
    
    return cell;
}

-(IBAction)addTerr:(id)sender {
    SDAddTerritoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addterr"];
    [self presentViewController:vc animated:YES completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
