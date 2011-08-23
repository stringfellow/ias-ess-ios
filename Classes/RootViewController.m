//
//  iAssessViewController.m
//  iAssess
//
//  Created by Steve Pike on 17/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import "RootViewController.h"
#import "AddSightingViewController.h"

@implementation RootViewController

@synthesize tableView;
@synthesize activeField;
@synthesize emailCell;
@synthesize emailField;

#pragma mark Instance Methods

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



//-(IBAction)backgroundTouched:(id)sender
//{
//	[emailField resignFirstResponder];
//}
	

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title = @"iAssess";
    [super viewDidLoad];
	[self registerForKeyboardNotifications];
	[self loadPrefsFromPList];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[tableView release];
    [super dealloc];
}

#pragma mark Keyboard showing stuff

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
	
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    tableView.contentInset = contentInsets;
    tableView.scrollIndicatorInsets = contentInsets;
	
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
	CGPoint origin = activeField.frame.origin;
	origin.y -= tableView.contentOffset.y;
	//    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
	CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y+(aRect.size.height));
	[tableView setContentOffset:scrollPoint animated:YES];
	//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    tableView.contentInset = contentInsets;
    tableView.scrollIndicatorInsets = contentInsets;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

-(IBAction)textFieldReturn:(id)sender
{
	[self savePrefsToPList];
	[sender resignFirstResponder];
}

#pragma mark Save/Load user prefs

- (void)savePrefsToPList {
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
	
	[data setObject:emailField.text forKey:@"email"];
	
	[data writeToFile: path atomically:YES];
	[data release];
}

- (void)loadPrefsFromPList {
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
	
	if ([savedData objectForKey:@"email"])
		emailField.text = [savedData objectForKey:@"email"];
	
	[savedData release];
}



#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tv
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];

	if (nil == cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"cell"] autorelease];
	}
	
	switch (indexPath.section) 
	{
		case 0: switch (indexPath.row) {
			case 0: cell.textLabel.text = @"Add sighting";
				break;
			case 1: cell.textLabel.text = @"About";
				break;
			case 2: cell.textLabel.text = @"Go to website";
				break;
		} break;
		case 1: switch (indexPath.row) {
			case 0: cell = emailCell;
				break;
		}
	}
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(section == 0)
		return @"Actions";
	else
		return @"Configuration";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 2;
}

- (NSInteger)tableView:(UITableView *)tv
	numberOfRowsInSection:(NSInteger)section
{
	if (section == 0){
		return 3;
	}
	if (section == 1){
		return 1;
	}
	return 0;
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0){
		if (indexPath.row == 0) {
			AddSightingViewController *sighting = [[AddSightingViewController alloc] initWithEmailAddress: emailField.text];
			[self.navigationController pushViewController:sighting animated:YES];
			[sighting release];
		}
		if (indexPath.row == 1) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iAssess"
															message:@"iAssess provides a quick way to log sightings of Invasive Alien Species (IAS). See http://ias-ess.org for more details."
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert autorelease];
			[alert show];
		}
		if (indexPath.row == 2){
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.ias-ess.org"]];
		}
	}
	[tv deselectRowAtIndexPath:indexPath animated:YES];
}


@end
