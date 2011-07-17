//
//  iAssessViewController.m
//  iAssess
//
//  Created by Steve Pike on 17/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import "RootController.h"
#import "iAssessDelegate.h"
#import "AddSightingController.h"

@implementation RootController

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
	UITableViewCell *cell = 
	[tv dequeueReusableCellWithIdentifier:@"cell"];
	if (nil == cell) {
		cell = [[[UITableViewCell alloc]
				 initWithFrame:CGRectZero reuseIdentifier:@"cell"] autorelease];
	}
	
	switch ([indexPath indexAtPosition:1]) 
	{
		case 0: cell.textLabel.text = @"Add sighting";
			break;
		case 1: cell.textLabel.text = @"About";
			break;
		case 2: cell.textLabel.text = @"Something";
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

- (void)tableView:(UITableView *)tv
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	iAssessDelegate *delegate =
	(iAssessDelegate *)[[UIApplication sharedApplication] delegate];
	AddSightingController *sighting = [[AddSightingController alloc] init];
	
	if ([indexPath indexAtPosition:1] == 0) {
		[delegate.navController pushViewController:sighting animated:YES];
		[sighting release];
	}	
		
	[tv deselectRowAtIndexPath:indexPath animated:YES];
}


@end
