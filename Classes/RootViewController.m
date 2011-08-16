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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title = @"iAssess";
    [super viewDidLoad];
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

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tv
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];

	if (nil == cell) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"cell"] autorelease];
	}
	
	switch (indexPath.row) 
	{
		case 0: cell.textLabel.text = @"Add sighting";
			break;
		case 1: cell.textLabel.text = @"About";
			break;
		case 2: cell.textLabel.text = @"Go to website";
			break;
			
	}
	return cell;
}

- (NSInteger)tableView:(UITableView *)tv
	numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
		AddSightingViewController *sighting = [[AddSightingViewController alloc] init];
		[self.navigationController pushViewController:sighting animated:YES];
		[sighting release];
	}
	if (indexPath.row == 1) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iAssess"
														message:@"iAssess provides a quick way to log sightings of Invasive Alien Species (IAS). See http://ias-ess.appspot.com for more details."
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert autorelease];
		[alert show];
	}
	if (indexPath.row == 2){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://ias-ess.appspot.com"]];
	}
		
	[tv deselectRowAtIndexPath:indexPath animated:YES];
}


@end
