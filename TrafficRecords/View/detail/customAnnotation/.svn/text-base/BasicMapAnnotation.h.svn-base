#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "BMapKit.h"

@interface BasicMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
