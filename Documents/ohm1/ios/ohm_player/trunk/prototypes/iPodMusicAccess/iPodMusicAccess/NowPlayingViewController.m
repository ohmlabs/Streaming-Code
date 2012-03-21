//
//  NowPlayingViewController.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "NowPlayingViewController.h"

#import <MediaPlayer/MediaPlayer.h>

#import "MusicPLayer.h"
#import "OhmTargetConditionals.h"

@interface NowPlayingViewController (ForwardDeclarations)

- (void) updateCurrentPlayingItem;

@end

@implementation NowPlayingViewController

@synthesize volumeControlView;
@synthesize airplayControllView;
@synthesize albumTitle;
@synthesize artistName;
@synthesize songTitle;
@synthesize albumArtView;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark Notification - Handlers

- (void) handleSongChange:(NSNotification*)note
{
	[self updateCurrentPlayingItem];
}

- (void) handlePlaybackChange:(NSNotification*)note
{
	
#if OHM_TARGET_SIMULATE
	MusicPlayer* player = [note object];

	if (player.isStopped)
#else
	MPMusicPlayerController* player = [note object];
	
	if (player.playbackState == MPMusicPlaybackStateStopped)
#endif
	{
		// Hide the Now Playing view controller when playback ends...
		
		[[self navigationController] popViewControllerAnimated:YES];
	}
	
}

#pragma mark Notification - Registration

- (void) registerForNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleSongChange:)
												 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handlePlaybackChange:)
												 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
											   object:nil];
}

- (void) unregisterForNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Protected Methods

- (MusicPlayer*) musicPlayer
{
	return musicPlayer();
}

- (UIColor*) backgroundColor
{
	return [UIColor blackColor];
}

- (void) setStatusBarColor
{
	savedStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
}

- (void) unsetStatusBarColor
{
	[[UIApplication sharedApplication] setStatusBarStyle:savedStatusBarStyle animated:YES];
}

- (void) setNavigationBarColor
{
	savedNavigationBarColor = [self navigationController].navigationBar.tintColor;
	
	[self navigationController].navigationBar.tintColor = [self backgroundColor];
}

- (void) unsetNavigationBarColor
{
	[self navigationController].navigationBar.tintColor = savedNavigationBarColor;
}

- (void) setColorScheme
{
	[self setStatusBarColor];
	[self setNavigationBarColor];
}

- (void) unsetColorScheme
{
	[self unsetStatusBarColor];
	[self unsetNavigationBarColor];
}

- (void) setUpAirPlayControl
{
	UIView* parentView = self.airplayControllView;
	
	parentView.backgroundColor = [UIColor clearColor];
	
	MPVolumeView *controlView = [[MPVolumeView alloc] init];
	
	[controlView setShowsVolumeSlider:NO];
	[controlView setShowsRouteButton:YES];
	[controlView sizeToFit];
	
	[parentView addSubview:controlView];
}

- (void) setUpVolumeControl
{
	UIView* parentView = self.volumeControlView;
	
	parentView.backgroundColor = [UIColor clearColor];
	
	MPVolumeView *controlView = [[MPVolumeView alloc] init];
	
	[controlView setShowsVolumeSlider:YES];
	[controlView setShowsRouteButton:NO];
	[controlView sizeToFit];
	
	controlView.frame = parentView.bounds;
	
	[parentView addSubview:controlView];
}

- (void) updateCurrentPlayingItem
{
	MusicPlayer* musicPlayer = [self musicPlayer];
	
	albumTitle.text	= musicPlayer.currentAlbumTitle;
	artistName.text	= musicPlayer.currentArtistName;
	songTitle.text	= musicPlayer.currentSongTitle;
	
	// Note: we're using the iPod music player so we shouldn't have
	// to update the music info for Airplay...
}

#pragma mark UIViewController Methods

- (void) viewDidLoad
{	
	self.view.backgroundColor = [self backgroundColor];
	
	// Clear the placeholder text in the storyboard.
	
	albumTitle.text	= nil;
	artistName.text	= nil;
	songTitle.text	= nil;
	
	[self setUpAirPlayControl];
	[self setUpVolumeControl];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[self setVolumeControlView:nil];
	[self setAirplayControllView:nil];
	[self setArtistName:nil];
	[self setAlbumTitle:nil];
	[self setSongTitle:nil];
	[self setAlbumArtView:nil];
}

- (void) viewWillAppear:(BOOL)animated
{	
	[self registerForNotifications];
	
	[self setColorScheme];
	
	[super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{	
	[self unregisterForNotifications];
	
	[self unsetColorScheme];
	
	[super viewWillDisappear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
	[self updateCurrentPlayingItem];
	
	[super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Actions

- (IBAction)skipToPreviousItem
{
	[[self musicPlayer] skipToPreviousItem];
}

- (IBAction)play
{
	// $$$$$ There are only placeholder graphics for now, so simulate
	// a pause button...
	
	([self musicPlayer].isPlaying) ? [[self musicPlayer] pause] : [[self musicPlayer] play];
}

- (IBAction)skipToNextItem
{
	[[self musicPlayer] skipToNextItem];
}

@end
