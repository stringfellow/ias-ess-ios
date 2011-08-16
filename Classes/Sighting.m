//
//  Sighting.m
//  iAssess
//
//  Created by Steve Pike on 17/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import "Sighting.h"


@implementation Sighting

@synthesize taxonName;
@synthesize taxonPK;
@synthesize location;
@synthesize useImageLocation;
@synthesize email;
@synthesize dateTime;
@synthesize photo;
@synthesize thumbnail;
@synthesize contactable;

-(void) dealloc {
	[taxonName release];
	[taxonPK release];
	[location release];
	[useImageLocation release];
	[email release];
	[contactable release];
	[dateTime release];
	[photo release];
	[thumbnail release];
	[super dealloc];
}

@end
