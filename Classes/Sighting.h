//
//  Sighting.h
//  iAssess
//
//  Created by Steve Pike on 17/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface Sighting : NSObject {
	NSString *taxonName;
	CLLocation *location;
	NSString *email;
	NSNumber *contactable;
	NSDate *dateTime;
	UIImage *photo;
}

@property (nonatomic, retain) NSString *taxonName;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSNumber *contactable;
@property (nonatomic, retain) NSDate *dateTime;
@property (nonatomic, retain) UIImage *photo;



@end
