//
//  HowtoViewController.h
//  DJReptile
//
//  Created by Carsten Graf on 02.03.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HowtoViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,MKAnnotation> {


    NSMutableArray *json;
   // MKMapView *myMapView;
    NSMutableArray *mapAnnotations;
    NSMutableArray *descriptions;

}

@property (strong, nonatomic) IBOutlet MKMapView *myMapView;


- (IBAction)showLocation:(id)sender;
- (IBAction)MapType:(id)sender;
- (IBAction)showgigs:(id)sender;


@end
