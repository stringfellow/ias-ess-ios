//
//  AddSightingController.h
//  iAssess
//
//  Created by Steve Pike on 17/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sighting.h"

@interface AddSightingController : UIViewController 
	<
		UIPickerViewDataSource, UIPickerViewDelegate,
		CLLocationManagerDelegate
	> {
	
	UIPickerView *taxaPicker;
	CLLocationManager *locationManager;
	NSMutableArray *taxa;
	NSMutableData *responseData;
	Sighting *newSighting;

}

@property (nonatomic, retain) IBOutlet UIPickerView *taxaPicker;
@property (nonatomic, retain) IBOutlet Sighting *newSighting;

- (void) getTaxa;

@end
