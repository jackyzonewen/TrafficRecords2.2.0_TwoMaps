#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "BMapKit.h"

@interface CalloutMapAnnotation : NSObject <MKAnnotation, BMKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;

// Title and subtitle for use by selection UI.
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
