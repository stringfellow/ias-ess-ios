//
//  GetPhoto.m
//  iAssess
//
//  Created by Steve Pike on 17/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import "GetPhotoController.h"
#import "iAssessDelegate.h"
#import "Sighting.h"


@implementation GetPhotoController

@synthesize imagePicker;
@synthesize imageView;
@synthesize newSighting;
@synthesize delegate;


//- (GetPhotoController*)initWithSighting:(Sighting*)aSighting {
//	if((self = [super initWithNibName:@"GetPhotoController" bundle:nil])) {
//		self.newSighting = aSighting;
//	}
//	return self;
//}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.allowsEditing = YES;
	imagePicker.delegate = self;
	imagePicker.sourceType = 
		UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark My Stuff

- (IBAction)showPicker:(id)sender {
	[self presentModalViewController:imagePicker animated:YES];
}

- (IBAction)done:(id)sender {
	[self.delegate photoGetViewController:self
							  didGetPhoto:imageView.image];
}


#pragma mark UIImagePickerControllerDelegate Methods


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissModalViewControllerAnimated:YES];
	//newSighting.photo = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	imageView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	NSLog(@"TEST!");
}




@end