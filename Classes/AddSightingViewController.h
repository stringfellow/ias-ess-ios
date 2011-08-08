//
//  AddSightingController.h
//  iAssess
//
//  Created by Steve Pike on 17/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Sighting.h"
#import "QuestionnaireViewController.h"

@interface AddSightingViewController : UIViewController 
	<
		UIPickerViewDataSource, UIPickerViewDelegate,
		CLLocationManagerDelegate,
		UIImagePickerControllerDelegate,
		UINavigationControllerDelegate,
		UITableViewDataSource, UITableViewDelegate,
		UIActionSheetDelegate,
		QuestionnaireDelegate
	> {
	
	UIPickerView *taxaPicker;
	CLLocationManager *locationManager;
	
	NSMutableArray *taxa;
	NSMutableData *responseData;

}

@property (nonatomic, retain) IBOutlet UIPickerView *taxaPicker;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *taxaLabel;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) IBOutlet UITableViewCell *imageCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *taxaCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *locationCell;

@property (nonatomic, retain) IBOutlet NSURL *currentURL;
@property (nonatomic, retain) IBOutlet NSURL *sightingURL;

@property (nonatomic, retain) IBOutlet Sighting *newSighting;


- (void) getTaxa;
- (IBAction)addImage:(id)sender;
- (IBAction)doneImage:(id)sender;
- (IBAction)pickTaxa:(id)sender;
- (IBAction)updateUIInfo;
- (IBAction)uploadImage;

@end
