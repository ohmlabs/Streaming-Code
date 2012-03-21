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
}

@property (nonatomic, strong) IBOutlet UIView* volumeControlView;
@property (nonatomic, strong) IBOutlet UIView* airplayControllView;

@property (nonatomic, strong) IBOutlet UILabel* artistName;
@property (nonatomic, strong) IBOutlet UILabel* albumTitle;
@property (nonatomic, strong) IBOutlet UILabel* songTitle;
@property (nonatomic, strong) IBOutlet UIImageView* albumArtView;

- (IBAction)skipToPreviousItem;
- (IBAction)play;
- (IBAction)skipToNextItem;

@end
