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
#import "GetPhotoController.h"
#import "JSON/JSON.h"
#import "Sighting.h"


@implementation AddSightingController

@synthesize taxaPicker;
@synthesize taxaCell;

@synthesize imageView;
@synthesize imagePicker;
@synthesize imageCell;
@synthesize taxaLabel;

@synthesize mapView;
@synthesize locationCell;

@synthesize tableView;

@synthesize newSighting;




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
	
	taxaPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,100, 320, 216)];
	taxaPicker.delegate = self;
	taxaPicker.dataSource = self;
	taxaPicker.showsSelectionIndicator = YES;
	
	
	self.title = @"Add sighting";
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

- (IBAction)pickTaxa:(id)sender {
	/* first create a UIActionSheet, where you define a title, delegate and a button to close the sheet again */
	UIActionSheet *actionSheet = [
								  [UIActionSheet alloc]
									initWithTitle:@"Select taxon"
									delegate:self
								    cancelButtonTitle:@"Done"
								    destructiveButtonTitle:nil otherButtonTitles:nil];


	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	
	//UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
//	closeButton.momentary = YES; 
//	closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
//	closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
//	closeButton.tintColor = [UIColor blackColor];
//	[closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
	//[actionSheet addSubview:closeButton];
	
	/* Add the UIActionSheet to the view */
	[actionSheet showInView:self.view];
	
	/* Make sure the UIActionSheet is big enough to fit your UIPickerView and it's buttons */
	[actionSheet setBounds:CGRectMake(0, 0, 320, 521)];
	
	/* Add the UIPickerView to the UIActionSheet */
	[actionSheet addSubview:taxaPicker];
	
	[taxaPicker selectRow:0 inComponent:0 animated:NO];
	
	/* clean up */
	[actionSheet release];
}

- (IBAction)dismissActionSheet:(id)sender {
	NSLog(@"DISMISS");
}

- (IBAction)addImage:(id)sender {
	GetPhotoController *gp = [[GetPhotoController alloc]
							  initWithNibName:@"GetPhotoController" bundle:nil];
	[gp setDelegate:self];
	[self presentModalViewController:gp animated:YES];
	[gp release];
}

- (void)updateUIInfo {
	[mapView setCenterCoordinate:newSighting.location.coordinate animated:YES];
	//NSLog(@"Location: %@", newSighting.location.coordinate);
	imageView.image = newSighting.photo;
	taxaLabel.text = newSighting.taxonName;
}


- (IBAction)doneImage:(id)sender {
	imageView.image = newSighting.photo;
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
	[self updateUIInfo];

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

#pragma mark GetPhotoDelegate Methods


- (void)photoGetViewController:(GetPhotoController *)photoGetController
				   didGetPhoto:(UIImage *)photo {
	if (photo) {
		newSighting.photo = photo;
		[self updateUIInfo];
	}
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
	
	switch ( indexPath.row ){
		case 0: cell = imageCell;
			break;
		case 1: cell = taxaCell;
			break;
		case 2: cell = locationCell;
			break;
	}
	
	return cell;
}


#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch ( indexPath.row ){
		case 0: return 210;
		case 1: return 44;
		case 2: return 210;
	}
	return 44;
}

#pragma mark UIActionSheet Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    newSighting.taxonName = @"Dave";
	[self updateUIInfo];
}

@end
