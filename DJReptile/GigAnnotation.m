//
//  GigAnnotation.m
//  DJReptile
//
//  Created by Carsten Graf on 08.03.13.
//  Copyright (c) 2013 Carsten Graf. All rights reserved.
//

#import "GigAnnotation.h"

@implementation MapViewAnnotation

@synthesize title, coordinate;

-(id)initWithTitle:(NSString *)ttl andSubtitle:(NSString *)sub andCoordinate:(CLLocationCoordinate2D)c2d
{
    coordinate = c2d;
    title = ttl;
    subtitle = sub;
    
    return self;
}


@end
