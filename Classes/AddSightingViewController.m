//
//  AddSightingController.m
//  iAssess
//
//  Created by Steve Pike on 17/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "AddSightingViewController.h"
#import "iAssessDelegate.h"
#import "JSON/JSON.h"
#import "Sighting.h"
#import "QuestionnaireViewController.h"
#import "UIImage+Resize.h"


@implementation AddSightingViewController

@synthesize taxaPicker;
@synthesize taxaCell;

@synthesize imageView;
@synthesize imageCell;
@synthesize taxaLabel;

@synthesize mapView;
@synthesize locationCell;
@synthesize imageLocationSwitch;

@synthesize tableView;

@synthesize newSighting;

@synthesize currentURL;
@synthesize sightingURL;




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
	
	self.title = @"Add sighting";

	// Should move this taxa stuff out into its own class (dedicated to fetching data from the web service)
	iAssessDelegate *delegate =
		(iAssessDelegate *)[[UIApplication sharedApplication] delegate];
	taxa = delegate.taxa;
	
	responseData = [[NSMutableData data] retain];
	newSighting = [[Sighting alloc] init];
	newSighting.useImageLocation = [NSNumber numberWithBool:imageLocationSwitch.on];
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	if ([CLLocationManager locationServicesEnabled]) {
		[locationManager startUpdatingLocation];
	} else {
		NSLog(@"No location service :(");
	}
	
	taxaPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, 320, 216)];
	taxaPicker.delegate = self;
	taxaPicker.dataSource = self;
	taxaPicker.showsSelectionIndicator = YES;
	
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
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

- (void)doneButtonClicked:(id)sender
{
	[self uploadImage];
		
	QuestionnaireViewController *qv = [[QuestionnaireViewController alloc] initWithNibName:@"QuestionnaireViewController" bundle:nil];
	qv.delegate = self;
	[self presentModalViewController:qv animated:YES];
	[qv release];
	
	// We'll dismiss the current view later (when the modal view is dismissed) - it looks neater and it's more obvious to the user what is happening
	self.navigationItem.rightBarButtonItem.enabled = NO;
}


# pragma mark My Stuff

- (IBAction)switchLocationMethod:(id)sender {
	newSighting.useImageLocation = [NSNumber numberWithBool:imageLocationSwitch.on];
}

- (void)saveTaxaToPList {
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
	NSString *documentsDirectory = [paths objectAtIndex:0]; //2
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; //3
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath: path]) //4
	{
		NSString *bundle = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]; //5
		
		[fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
	}

	
	NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
		
	[data setObject:taxa forKey:@"taxa"];
	
	[data writeToFile: path atomically:YES];
	[data release];
}

- (void)loadTaxaFromPList {
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
	NSString *documentsDirectory = [paths objectAtIndex:0]; //2
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; //3
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath: path]) //4
	{
		NSString *bundle = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]; //5
		
		[fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
	}
	
	NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
	
	NSArray *taxaList = [savedData objectForKey:@"taxa"];
	
	for (int i = 0; i < [taxaList count]; i++)
		[taxa addObject:[taxaList objectAtIndex:i]];
	
	[taxaPicker reloadAllComponents];
	
	[savedData release];
}

- (void)getTaxa {
	NSURL *url = [[NSURL URLWithString:API_TAXA_LIST] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[[NSURLConnection alloc]
	 initWithRequest:request delegate:self];
	NSLog(@"GET TAXA");
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
	
	BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
	BOOL photosAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
	
	// There's probably a slightly more concise way of doing this...
	UIActionSheet *actionSheet;
	
	if (cameraAvailable && photosAvailable)
	{
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
																 delegate:self 
														cancelButtonTitle:@"Cancel" 
												   destructiveButtonTitle:nil 
														otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
	} else if (cameraAvailable)
	{
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
																 delegate:self 
														cancelButtonTitle:@"Cancel" 
												   destructiveButtonTitle:nil 
														otherButtonTitles:@"Take Photo", nil];
	} else if (photosAvailable) 
	{
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
																 delegate:self 
														cancelButtonTitle:@"Cancel" 
												   destructiveButtonTitle:nil 
														otherButtonTitles:@"Choose Existing", nil];	
	} else 
	{
		// Display alert - no images available!
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No photo source available" 
														message:@"Your device doesn't appear to have a camera or photo library, so you can't add any photos!" 
													   delegate:nil 
											  cancelButtonTitle:@"Back" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}

	if (actionSheet)
	{
		actionSheet.actionSheetStyle = UIActionSheetStyleDefault;

		[actionSheet showInView:self.view];
		[actionSheet release];
	}
}

- (void)updateUIInfo {
	NSLog(@"UPDATE UI");
	
	if ([newSighting.useImageLocation boolValue] == YES) {
			// TODO: Get EXIF GPS
	}
	
	[mapView setCenterCoordinate:newSighting.location.coordinate animated:YES];
	// a little bit arbitrary!
	MKCoordinateSpan span = {latitudeDelta: 0.001, longitudeDelta: 0.001};
	MKCoordinateRegion region = {newSighting.location.coordinate, span};
	[mapView setRegion:region animated: YES];
	
	imageView.image = newSighting.thumbnail;
	
	taxaLabel.text = newSighting.taxonName;
	
}


- (IBAction)doneImage:(id)sender {
	imageView.image = newSighting.photo;
}

- (void)sendSighting {
	
}

- (IBAction)uploadImage {

	UIImage *image = [imageView image];
	NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:API_SIGHTING_POST]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
	 */
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	
	//lat
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lat\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%f", newSighting.location.coordinate.latitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

	//lon
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lon\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%f", newSighting.location.coordinate.longitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//taxa
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"taxon\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%@", newSighting.taxonPK] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//image
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"image\"; filename=\"iPhonePhoto.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	//NSLog(returnString);
	
	sightingURL = [[NSURL alloc] initWithString:returnString];
	
}


#pragma mark NSURLConnection Methods

- (void)connection:(NSURLConnection *)connection
		didReceiveData:(NSData *)data
{
	NSLog(@"Connection: %@", connection);
	NSLog(@"URL: %@", [currentURL path]);
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
	currentURL = [response URL];
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	NSLog(@"Error in req.: %@", error);
	[self loadTaxaFromPList];
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

	[self saveTaxaToPList];
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
	NSLog(@"taxa: %@", taxa);
	return [[taxa objectAtIndex:row] objectAtIndex:1];
}


#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
	fromLocation:(CLLocation *)oldLocation
{
	if ([newSighting.useImageLocation boolValue] == NO) {
		newSighting.location = newLocation;
		newSighting.dateTime = newLocation.timestamp;
		[self updateUIInfo];
	}

}

- (void)locationManager:(CLLocationManager *)manager
    didFailWithError:(NSError *)error
{
	if ([newSighting.useImageLocation boolValue] == NO) {
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
		case 0: return 140;
		case 1: return 44;
		case 2: return 197;
	}
	return 44;
}

#pragma mark UIActionSheet Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if (actionSheet.title == @"Select taxon")	// should do this more neatly, but for now we'll just detect which actionsheet we're dealing with by the title
	{
		if (![taxaPicker numberOfRowsInComponent: 0])
			return;
		newSighting.taxonName = [self pickerView:taxaPicker titleForRow:[taxaPicker selectedRowInComponent:0] forComponent:0];
		newSighting.taxonPK = [[taxa objectAtIndex:[taxaPicker selectedRowInComponent:0]] objectAtIndex:0];
		[self updateUIInfo];
	}
	else 
	{
		if (buttonIndex == actionSheet.cancelButtonIndex)
			return;
		
		// for now we'll just assume it's the image picker sheet
		UIImagePickerController	*imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		
		if ([actionSheet buttonTitleAtIndex:buttonIndex] == @"Take Photo")
			imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		else if ([actionSheet buttonTitleAtIndex:buttonIndex] == @"Choose Existing")
			imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		
		[self presentModalViewController:imagePicker animated:YES];
		[imagePicker release];
	}

}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
	//NSDictionary *meta = [info valueForKey:UIImagePickerControllerMediaMetadata];
	//NSLog(@"info: %@", info);	
	//NSLog(@"meta: %@", meta);
	
	UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
	if (!image)
		image = [info valueForKey:UIImagePickerControllerOriginalImage];
	
	//if (!image)
	//	NSLog(@"NO BLOODY IMAGE!");
    newSighting.photo = image;
	//if (!newSighting.photo)
	//	NSLog(@"NO BLOODY PHOTO!");
	newSighting.thumbnail = [image thumbnailImage:100
							transparentBorder:1
							cornerRadius: 15
							interpolationQuality:3];
	//if (!newSighting.thumbnail)
	//	NSLog(@"NO BLOODY THUMB!");
	[self updateUIInfo];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark QuestionnaireDelegate methods

- (NSURL *)questionnaireView:(QuestionnaireViewController *)qv
			URLForWebView:(UIWebView *)wv {
	
	return sightingURL;
}

- (void)dismissQuestionnaireView:(QuestionnaireViewController *)qv {
	NSLog(@"Dismiss!");
	[self dismissModalViewControllerAnimated:YES];
	NSLog(@"Dismissed!");
}

- (void)questionnaireViewDidDisappear:(QuestionnaireViewController *)qv {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
