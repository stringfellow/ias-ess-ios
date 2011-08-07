//
//  QuestionnaireView.h
//  iAssess
//
//  Created by Steve Pike on 21/07/2011.
//  Copyright 2011 Synfinity (steve@synfinity.net). All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuestionnaireDelegate;

@interface QuestionnaireView : UIViewController <UINavigationControllerDelegate> {

	UIWebView *webView;
	id <QuestionnaireDelegate> delegate;
	
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (assign, nonatomic) id <QuestionnaireDelegate> delegate;

- (IBAction)done:(id)sender;

@end


@protocol QuestionnaireDelegate <NSObject>

- (void)questionnaireView:(QuestionnaireView *)qv
                   setURLForWebView:(UIWebView *)wv;

- (void)dismissQuestionnaireView:(QuestionnaireView *)qv;

@end
