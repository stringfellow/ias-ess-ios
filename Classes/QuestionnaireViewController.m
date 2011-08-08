//
//  QuestionnaireView.m
//  iAssess
//
//  Created by Steve Pike on 21/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import "QuestionnaireViewController.h"
#import "iAssessDelegate.h"

@implementation QuestionnaireViewController

@synthesize webView;
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
	[super viewDidLoad];

	if (self.delegate) [webView loadRequest:[NSURLRequest requestWithURL:[self.delegate questionnaireView:self URLForWebView:webView]]];
}

- (void)viewDidDisappear:(BOOL)animated
{
	if (self.delegate) [self.delegate questionnaireViewDidDisappear:self];
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

- (IBAction)done:(id)sender {
	NSLog(@"DONE!");
	//DEBUG MEEEEEEEEEEE!
	[self.delegate dismissQuestionnaireView:self];
	//NSLog(@"DONE DID IT!");
}

- (void)dealloc {
    [super dealloc];
}


@end
