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
	imagePicker.sourceType = 
	UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	[self presentModalViewController:imagePicker animated:YES];
}

- (IBAction)showCamera:(id)sender {
	imagePicker.sourceType = 
	UIImagePickerControllerSourceTypeCamera;
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
	//[picker release];
	NSLog(@"%@", info);
	imageView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
}




@end
