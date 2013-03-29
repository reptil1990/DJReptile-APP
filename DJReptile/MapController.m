//
//  HowtoViewController.m
//  DJReptile
//
//  Created by Carsten Graf on 02.03.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//


#import "MapController.h"
#import "GigAnnotation.h"

#define kGETUrl @"http://reptil1990.funpic.de/getjsongigs.php"



@implementation MapController

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
	// Do any additional setup after loading the view
    
    _updateEvents = [NSMutableArray array];
    
    
    self.locationManager.delegate = self;
    self.myMapView.delegate = self;

    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest; // Best
    [_locationManager startUpdatingLocation];
    

    mapAnnotations = [[NSMutableArray alloc] initWithCapacity:2];
    descriptions = [NSMutableArray array];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    
    NSArray *regions = [[_locationManager monitoredRegions] allObjects];
    NSLog(@"Monitored Reagions: %@",regions);

}

#pragma mark Data Handling
//Get Data from Database
-(void) getData:(NSData *) data{
    
    NSError *error;
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSLog(@"Error: %@",error);
    
}



-(void) start {
    
    NSURL *url = [NSURL URLWithString:kGETUrl];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [self getData:data];
    
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Map handling

//Show user Location
- (IBAction)showLocation:(id)sender {
    
    
    self.myMapView.showsUserLocation=YES;
    [self.myMapView setUserTrackingMode:MKUserTrackingModeFollow];
    
    
    NSString *lon = [NSString stringWithFormat:@"Lon: %f and Lat: %f",_locationManager.location.coordinate.longitude,_locationManager.location.coordinate.latitude];
    NSLog(@"Update Location: %@",lon);
    
}



//Chance Map Type
- (IBAction)MapType:(id)sender {
    
        switch (((UISegmentedControl*)sender).selectedSegmentIndex) {
            
            case 0: [self.myMapView setMapType:MKMapTypeStandard];
            break;
            
            case 1:[self.myMapView setMapType:MKMapTypeSatellite];
            break;
            
            case 2: [self.myMapView setMapType:MKMapTypeHybrid];
            break;
            
        default: [self.myMapView setMapType:MKMapTypeStandard];
            break;
    }
    
    
}

//Show annotation Pins
-(IBAction)showgigs:(id)sender
{

    [self creatAllAnnotations];
    
   // self.myMapView.showsUserLocation = NO;
}

//Annotation view create style
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    
    if ([views count] == 1 && [json count] == 1){
        
        
        MKAnnotationView *annotationView = [views objectAtIndex:0];
        id <MKAnnotation> mp = [annotationView annotation];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1000, 1000);
        [mv setRegion:region animated:YES];
    }
}



//Read all annotations from DB and creat it
-(void)creatAllAnnotations
{
    
    [self start];
    
    for (int i = 0; i<[json count]; i++) {
        
    
    NSDictionary *info =  [json objectAtIndex:i];
        
    NSString *IDValue = [info objectForKey:@"id"];
    NSString *dbLonValue = [info objectForKey:@"lon"];
    NSString *dbLatValue = [info objectForKey:@"lat"];
    NSString *Title = [info objectForKey:@"Location"];
    NSString *Des = [info objectForKey:@"Description"];
    [descriptions addObject: Des];
    NSString *Subtitle = [NSString stringWithFormat:@"Date: %@ Time: %@",[info objectForKey:@"Date"],[info objectForKey:@"Time"]];
        
        CLLocationCoordinate2D location;
        location.latitude = [dbLatValue doubleValue];
        location.longitude = [dbLonValue doubleValue];
        
        MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:Title  andSubtitle:Subtitle andCoordinate:location];

        [self.myMapView addAnnotation:newAnnotation];
        
        [self addRegionwithLocation:&location andIdentifier:IDValue];
    
        
    }

}


//Did select an annotation
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{

    NSLog(@"Did select Annotation %@",view);
    
}

#pragma mark Annotation

//Annotation style
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    
	
        if([annotation isKindOfClass: [MKUserLocation class]])
        {
        return nil;
        }
    
        MKPinAnnotationView *pinView = nil;
    
        static NSString *defaultPinID = @"Place to be";
        pinView = (MKPinAnnotationView *)[self.myMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;


        return pinView;

    
}

#pragma mark Reagion handling

- (void)addRegionwithLocation:(CLLocationCoordinate2D*)location andIdentifier:(NSString*)ident{
    
	if ([CLLocationManager regionMonitoringAvailable]) {
		// Create a new region based on the parameters of the function.
		CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:*location radius:1000.0 identifier:ident];
		NSLog(@"Region: %@", newRegion);
		// Start monitoring the newly created region.
        [self monitorreagion:newRegion];
		[_locationManager startMonitoringForRegion:newRegion];
		
	}
	else {
		NSLog(@"Region monitoring is not available.");
	}
}

-(void)monitorreagion:(CLRegion*)reagion
{
    NSLog(@"Add reagion to loctionmanager: %@",reagion);
}



#pragma mark Location handling




- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region  {
	NSString *event = [NSString stringWithFormat:@"didEnterRegion %@ at %@", region.identifier, [NSDate date]];
	
	[self updateWithEvent:event];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait" message:@"You are only 1 km avay from DJ Reptile" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
	NSString *event = [NSString stringWithFormat:@"didExitRegion %@ at %@", region.identifier, [NSDate date]];
	
	[self updateWithEvent:event];
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
	NSString *event = [NSString stringWithFormat:@"monitoringDidFailForRegion %@: %@", region.identifier, error];
	
	[self updateWithEvent:event];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    
    NSString *lon = [NSString stringWithFormat:@"Lon: %f and Lat: %f",_locationManager.location.coordinate.longitude,_locationManager.location.coordinate.latitude];
    NSLog(@"Update Location: %@",lon);
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    
    
    NSLog(@"start monitoring new reagion: %@",region);
    
}

- (void)updateWithEvent:(NSString *)event {
	// Add region event to the updates array.
	[_updateEvents insertObject:event atIndex:0];
	
	// Update the icon badge number.
	[UIApplication sharedApplication].applicationIconBadgeNumber++;

}








@end
