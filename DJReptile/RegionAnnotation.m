
#import "RegionAnnotation.h"

@implementation RegionAnnotation

@synthesize region, coordinate, radius, title, subtitle;

- (id)init {
	self = [super init];
	if (self != nil) {
		self.title = @"Monitored Region";
	}
	
	return self;	
}


- (id)initWithCLRegion:(CLRegion *)newRegion {
	self = [self init];
	
	if (self != nil) {
		self.region = newRegion;
		self.coordinate = region.center;
		self.radius = region.radius;
		self.title = @"Monitored Region";
	}		

	return self;		
}


/*
 This method provides a custom setter so that the model is notified when the subtitle value has changed.
 */
- (void)setRadius:(CLLocationDistance)newRadius {
	[self willChangeValueForKey:@"subtitle"];
	
	radius = newRadius;
	
	[self didChangeValueForKey:@"subtitle"];
}


- (NSString *)subtitle {
	return [NSString stringWithFormat: @"Lat: %.4F, Lon: %.4F, Rad: %.1fm", coordinate.latitude, coordinate.longitude, radius];	
}


- (void)dealloc {
	[region release];
	[title release];
	[subtitle release];
	[super dealloc];
}


@end
