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
#import "AppDelegate.h"

@interface MapController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,MKAnnotation> {


    NSMutableArray *json;
    NSMutableArray *mapAnnotations;
    NSMutableArray *descriptions;
    BOOL isTracking;
    BOOL pendingRegionChange;

}

@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@property (nonatomic, retain) NSMutableArray *updateEvents;
@property (strong, nonatomic) CLLocationManager *locationManager;


- (IBAction)showLocation:(id)sender;
- (IBAction)MapType:(id)sender;
- (IBAction)showgigs:(id)sender;

- (void)updateWithEvent:(NSString *)event;


@end
