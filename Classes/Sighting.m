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
@synthesize location;
@synthesize email;
@synthesize dateTime;
@synthesize photo;
@synthesize contactable;

-(void) dealloc {
	[taxonName release];
	[location release];
	[email release];
	[contactable release];
	[dateTime release];
	[photo release];
	[super dealloc];
}

@end
