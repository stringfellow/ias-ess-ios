//
//  iAssessViewController.h
//  iAssess
//
//  Created by Steve Pike on 17/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> 
{
	UITableView *tableView;
	UITextField *activeField;
	UITextField *emailField;
	UITableViewCell *emailCell;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *activeField;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UITableViewCell *emailCell;

- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;
- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)registerForKeyboardNotifications;
- (IBAction)textFieldReturn:(id)sender;
//- (IBAction)backgroundTouched:(id)sender;
- (void)savePrefsToPList;
- (void)loadPrefsFromPList;



@end

