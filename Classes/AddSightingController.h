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
		CLLocationManagerDelegate,
		UIImagePickerControllerDelegate,
		UINavigationControllerDelegate
	> {
	
	UIPickerView *taxaPicker;
	CLLocationManager *locationManager;
	UIImagePickerController *imagePicker;
	UIImageView *imageView;
	NSMutableArray *taxa;
	NSMutableData *responseData;
	Sighting *newSighting;

}

@property (nonatomic, retain) IBOutlet UIPickerView *taxaPicker;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImagePickerController *imagePicker;
@property (nonatomic, retain) IBOutlet Sighting *newSighting;


- (void) getTaxa;
- (IBAction)addImage:(id)sender;

@end
