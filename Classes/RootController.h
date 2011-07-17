//
//  iAssessViewController.h
//  iAssess
//
//  Created by Steve Pike on 17/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootController : UIViewController <UITableViewDataSource, UITableViewDelegate> 
{
	UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end

