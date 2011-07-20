//
//  iAssessAppDelegate.h
//  iAssess
//
//  Created by Steve Pike on 17/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const API_TAXA_LIST;
extern NSString * const API_SIGHTING_POST;

@class RootController;

@interface iAssessDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootController *viewController;
	UINavigationController *navController;
	NSMutableArray *taxa;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) NSMutableArray *taxa;

@end

