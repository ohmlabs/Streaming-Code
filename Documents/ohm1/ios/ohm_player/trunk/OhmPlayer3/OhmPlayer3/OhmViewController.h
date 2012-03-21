//
//  OhmViewController.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SignInViewController.h"
#import "GalleryView.h"

@class GalleryView;
@class WireViewProvider;
@class NotificationListener;

@interface OhmViewController : UIViewController<SignInViewControllerDelegate, GalleryViewDelegate, GalleryViewDataSource>
{
	WireViewProvider* wireViewProvider;
	NotificationListener* playbackDidChangeListener;
}

@property (strong, nonatomic) IBOutlet GalleryView* wire;

@property (strong, nonatomic) IBOutlet UIView* navigationButtonsArea;

@property (strong, nonatomic) IBOutlet UIView* wireInspectorView;

@property (strong, nonatomic) IBOutlet UIView* postStatusBar;

@property (strong, nonatomic) IBOutlet UILabel* postStatusLabel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *postStatusButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *nowPlayingButton;

@end
