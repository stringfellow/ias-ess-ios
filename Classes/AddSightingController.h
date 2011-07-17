//
//  AddSightingController.h
//  iAssess
//
//  Created by Steve Pike on 17/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddSightingController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	
	UIPickerView *taxaPicker;
	NSMutableArray *taxa;
	NSMutableData *responseData;

}

@property (nonatomic, retain) IBOutlet UIPickerView *taxaPicker;

- (void) getTaxa;

@end
