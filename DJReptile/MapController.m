//
//  HowtoViewController.m
//  DJReptile
//
//  Created by Carsten Graf on 02.03.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import "MapController.h"
#import "GigAnnotation.h"
#import "DetailsOfGigViewController.h"
#define kGETUrl @"http://reptil1990.funpic.de/getjsongigs.php"



@implementation HowtoViewController

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
    
    
    self.myMapView.delegate = self;
    mapAnnotations = [[NSMutableArray alloc] initWithCapacity:2];
    descriptions = [NSMutableArray array];
   
}

//Get Data from Database
-(void) getData:(NSData *) data{
    
    NSError *error;
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
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


//Show user Location
- (IBAction)showLocation:(id)sender {
    
    
        self.myMapView.showsUserLocation=YES;

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
    
    self.myMapView.showsUserLocation = NO;
}


//Switch to Annotation viewController
-(void)switchView

{

    DetailsOfGigViewController *DetailsView = [[DetailsOfGigViewController alloc]init];
    [self.navigationController pushViewController:DetailsView animated:YES];

}

//Read all annotations from DB and creat it
-(void)creatAllAnnotations
{
    
    [self start];
    
    for (int i = 0; i<[json count]; i++) {
        
    
    NSDictionary *info =  [json objectAtIndex:i];
        
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
        
    
    }

}

//Did select an annotation
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"Did select Annotation %@",view);
    
}


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

    
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(switchView) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;

        return pinView;

    
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


@end
