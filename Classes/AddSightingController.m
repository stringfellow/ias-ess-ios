//
//  AddSightingController.m
//  iAssess
//
//  Created by Steve Pike on 17/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "AddSightingController.h"
#import "iAssessDelegate.h"
#import "JSON/JSON.h"
#import "Sighting.h"


@implementation AddSightingController

@synthesize taxaPicker;
@synthesize newSighting;
@synthesize imageView;
@synthesize imagePicker;

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
	iAssessDelegate *delegate =
	(iAssessDelegate *)[[UIApplication sharedApplication] delegate];
	taxa = delegate.taxa;
	responseData = [[NSMutableData data] retain];
	newSighting = [[Sighting alloc] init];
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	if ([CLLocationManager locationServicesEnabled]) {
		[locationManager startUpdatingLocation];
	} else {
		NSLog(@"No location service :(");
	}
	
	imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.allowsEditing = YES;
	imagePicker.delegate = self;
	imagePicker.sourceType = 
		UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	
	if ([taxa count] == 0) {
		[self getTaxa];
	}
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
	[newSighting dealloc];
    [super dealloc];
}

# pragma mark My Stuff

- (void)getTaxa {
	NSString *string = [NSString stringWithString:API_TAXA_LIST];
	NSURL *url = [[NSURL URLWithString:string] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[[NSURLConnection alloc]
	 initWithRequest:request delegate:self];
	
}

- (IBAction)addImage:(id)sender {
	[self presentModalViewController:imagePicker animated:YES];
}

#pragma mark NSURLConnection Methods

- (void)connection:(NSURLConnection *)connection
		didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
		willSendRequest:(NSURLRequest *)request
		redirectResponse:(NSURLResponse *)redirectResponse
{
	return request;
}

- (void)connection:(NSURLConnection *)connection
		didReceiveResponse:(NSURLResponse *)response
{
	
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	NSLog(@"Error in req.: %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
	NSArray *taxaList = [responseString JSONValue];
	[responseString release];
	
	for (int i = 0; i < [taxaList count]; i++)
		[taxa addObject:[taxaList objectAtIndex:i]];

	[taxaPicker reloadAllComponents];
}

#pragma mark UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pv
{
	return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pv numberOfRowsInComponent:(NSInteger)component
{
	return [taxa count];
	
}


- (NSString *)pickerView:(UIPickerView *)pv
	titleForRow:(NSInteger)row
	forComponent:(NSInteger)component
{
	return [taxa objectAtIndex:row];
}


#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
	fromLocation:(CLLocation *)oldLocation
{
	newSighting.location = newLocation;
	newSighting.dateTime = newLocation.timestamp;
}

- (void)locationManager:(CLLocationManager *)manager
    didFailWithError:(NSError *)error
{
	NSLog(@"Location error: %@", error);
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Location error"
						  message:@"Couldn't get location."
						  delegate:self
						  cancelButtonTitle:nil
						  otherButtonTitles:@"OK", nil];
	
	[alert show];
	[alert autorelease];
	
}

#pragma mark UIImagePickerControllerDelegate Methods


- (void)imagePickerController:(UIImagePickerController *)picker
	didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissModalViewControllerAnimated:YES];
	newSighting.photo = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	imageView.image = newSighting.photo;
}


@end
