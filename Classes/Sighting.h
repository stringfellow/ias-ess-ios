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
	NSNumber *taxonPK;
	CLLocation *location;
	NSNumber *useImageLocation;
	NSString *email;
	NSNumber *contactable;
	NSDate *dateTime;
	UIImage *photo;
	UIImage *thumbnail;
}

@property (nonatomic, retain) NSString *taxonName;
@property (nonatomic, retain) NSNumber *taxonPK;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSNumber *useImageLocation;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSNumber *contactable;
@property (nonatomic, retain) NSDate *dateTime;
@property (nonatomic, retain) UIImage *photo;
@property (nonatomic, retain) UIImage *thumbnail;


@end
