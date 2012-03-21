//
//  NowPlayingViewController.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NowPlayingViewController : UIViewController
{
	UIStatusBarStyle savedStatusBarStyle;
	UIColor* savedNavigationBarColor;

	NSTimer* playbackTimer;
}

@property (weak, nonatomic) IBOutlet UIView* volumeControlView;
@property (weak, nonatomic) IBOutlet UIView* airplayControllView;

@property (weak, nonatomic) IBOutlet UILabel* artistName;
@property (weak, nonatomic) IBOutlet UILabel* albumTitle;
@property (weak, nonatomic) IBOutlet UILabel* songTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeRemaining;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;
@property (weak, nonatomic) IBOutlet UILabel *songNumber;
@property (weak, nonatomic) IBOutlet UISlider *playbackTimeSlider;

@property (weak, nonatomic) IBOutlet UIView* albumArtView;

- (IBAction)skipToPreviousItem;
- (IBAction)play;
- (IBAction)skipToNextItem;
- (IBAction)sliderDidChange:(id)sender;
- (IBAction)compose:(id)sender;

@end
