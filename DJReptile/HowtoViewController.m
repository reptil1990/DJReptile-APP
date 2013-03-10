//
//  HowtoViewController.m
//  DJReptile
//
//  Created by Carsten Graf on 02.03.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import "HowtoViewController.h"
#import "GigAnnotation.h"
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
   
}



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

- (IBAction)showLocation:(id)sender {
    
    if (!self.myMapView.userLocationVisible)
    {
        self.myMapView.showsUserLocation=YES;
    }
}


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

-(IBAction)showgigs:(id)sender
{

    [self creatAllAnnotations];
}


-(void)showDiscription:(NSString*)dsc
{

    UIAlertView *waitalert = [[UIAlertView alloc] initWithTitle:@"Info" message:dsc delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [waitalert show];
}



-(void)creatAllAnnotations
{
    
    [self start];
    
    for (int i = 0; i<[json count]; i++) {
        
    
    NSDictionary *info =  [json objectAtIndex:i];
        
    NSString *dbLonValue = [info objectForKey:@"lon"];
    NSString *dbLatValue = [info objectForKey:@"lat"];
    NSString *Title = [info objectForKey:@"Location"];
    NSString *Des = [info objectForKey:@"Description"];
    NSString *Subtitle = [NSString stringWithFormat:@"Date: %@ Time: %@",[info objectForKey:@"Date"],[info objectForKey:@"Time"]];
        
        CLLocationCoordinate2D location;
        location.latitude = [dbLatValue doubleValue];
        location.longitude = [dbLonValue doubleValue];
        
        MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:Title  andSubtitle:Subtitle andCoordinate:location];

        [self.myMapView addAnnotation:newAnnotation];
        
    
    }

}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"Did select Annotation");
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    
	
        MKPinAnnotationView *pinView = nil;
    
        static NSString *defaultPinID = @"Place to be";
        pinView = (MKPinAnnotationView *)[self.myMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;

    
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;

        return pinView;

    
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    
    if([json count] == 1)
    {
    
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 2000, 2000);
	[mv setRegion:region animated:YES];
    }
}


@end
