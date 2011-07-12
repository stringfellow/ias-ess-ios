//
//  HelloWorldView.m
//  iOs
//
//  Created by Martin Allison on 12/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"


@implementation HelloWorldView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)drawRect:(CGRect) rect {
	
    NSString *hello   = @"Hello, World!";
	
    CGPoint  location = CGPointMake(10, 20);
	
    UIFont   *font    = [UIFont systemFontOfSize:24.0];
	
    [[UIColor whiteColor] set];
	
    [hello drawAtPoint:location withFont:font];
	
}

- (void)dealloc {
    [super dealloc];
}


@end
