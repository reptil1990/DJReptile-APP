//
//  AppDelegate.m
//  DJReptile
//
//  Created by Carsten Graf on 04.02.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    sleep(3);
    // Override point for customization after application launch.
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
   [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop significant location updates and start normal location updates again since the app is in the forefront.
        MapController *mapcontoller = [[MapController alloc]init];
        [mapcontoller.locationManager startMonitoringSignificantLocationChanges];
        [mapcontoller.locationManager stopUpdatingLocation];
        NSLog(@"Significant location change monitoring is available.");
        
    }
	else {
		NSLog(@"Significant location change monitoring is not available.");
	}
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop significant location updates and start normal location updates again since the app is in the forefront.
        MapController *mapcontoller = [[MapController alloc]init];
        [mapcontoller.locationManager stopMonitoringSignificantLocationChanges];
        [mapcontoller.locationManager startUpdatingLocation];
	NSLog(@"Significant location change monitoring is available.");
    }
	else {
		NSLog(@"Significant location change monitoring is not available.");
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{

    MapController *mapcontoller = [[MapController alloc]init];
    mapcontoller.locationManager = nil;

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




    


@end
