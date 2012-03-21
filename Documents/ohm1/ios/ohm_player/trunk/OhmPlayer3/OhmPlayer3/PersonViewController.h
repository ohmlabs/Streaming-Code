//
//  PersonViewController.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GalleryView.h"

@class Person;
@class GalleryView;
@class WireViewProvider;

@interface PersonViewController : UIViewController<GalleryViewDelegate, GalleryViewDataSource>
{
	WireViewProvider* wireViewProvider;
}

@property (nonatomic, retain) IBOutlet Person* person;

@property (nonatomic, retain) IBOutlet GalleryView* wire;

- (IBAction)rateUp:(id)sender;

@end
