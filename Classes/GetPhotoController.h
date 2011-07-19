//
//  GetPhoto.h
//  iAssess
//
//  Created by Steve Pike on 17/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sighting.h"

@protocol GetPhotoDelegate;

@interface GetPhotoController : UIViewController <
		UIImagePickerControllerDelegate,
		UINavigationControllerDelegate
	>
{	
	UIImagePickerController *imagePicker;
	NSMutableDictionary *commonData;
	UIImageView *imageView;
	Sighting *newSighting;
	id <GetPhotoDelegate> delegate;
}


@property (nonatomic, retain) Sighting *newSighting;

@property (nonatomic, retain) IBOutlet UIImagePickerController *imagePicker;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) id <GetPhotoDelegate> delegate;

- (IBAction)showPicker:(id)sender;
- (IBAction)done:(id)sender;


@end

@protocol GetPhotoDelegate <NSObject>

- (void)photoGetViewController:(GetPhotoController *)photoGetController
                   didGetPhoto:(UIImage *)photo;
@end
