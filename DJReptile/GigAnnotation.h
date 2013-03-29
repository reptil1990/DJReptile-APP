//
//  GigAnnotation.h
//  DJReptile
//
//  Created by Carsten Graf on 08.03.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation> {
    
	NSString *title;
    NSString *subtitle;
	CLLocationCoordinate2D coordinate;
    
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) CLRegion *region;
@property (nonatomic, readwrite) CLLocationDistance radius;

- (id)initWithTitle:(NSString *)ttl andSubtitle:(NSString*)sub andCoordinate:(CLLocationCoordinate2D)c2d;
- (id)initWithCLRegion:(CLRegion *)newRegion;

@end

