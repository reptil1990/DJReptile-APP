

#import <MapKit/MapKit.h>

@class GigAnnotation;

@interface RegionAnnotationView : MKPinAnnotationView {	
@private
	MKCircle *radiusOverlay;
	BOOL isRadiusUpdated;
}

@property (nonatomic, assign) MKMapView *map;
@property (nonatomic, assign) RegionAnnotation *theAnnotation;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation;
- (void)updateRadiusOverlay;
- (void)removeRadiusOverlay;

@end