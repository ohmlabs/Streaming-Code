//
//  NowPlayingViewController.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "NowPlayingViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <Twitter/Twitter.h>

#import "MusicPlayer.h"
#import "Song.h"
#import "OhmTargetConditionals.h"
#import "OhmBarButtonItems.h"
#import "OhmAppearance.h"

@interface NowPlayingViewController (ForwardDeclarations)

- (void) updateCurrentPlayingItem;

@end

static NSString* const NAV_BAR_BACKGROUND_IMAGE		= @"nav_bar_banner_home";
static NSString* const NAV_BAR_RIGHT_BUTTON_IMAGE	= @"custom_compose_bar_button";
static NSString* const PLACEHOLDER_ALBUM_IMAGE_NAME = @"default_album_artwork";
static NSString* const PLACEHOLDER_AIRPLAY_IMAGE	= @"placeholderAirplayButton";

@implementation NowPlayingViewController

@synthesize volumeControlView;
@synthesize airplayControllView;
@synthesize albumTitle;
@synthesize artistName;
@synthesize songTitle;
@synthesize albumArtView;
@synthesize timeRemaining;
@synthesize timeElapsed;
@synthesize songNumber;
@synthesize playbackTimeSlider;

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
#if OHM_TARGET_4
		[self updateCurrentPlayingItem];
#else
		// Hide the Now Playing view controller when playback ends...
		
		[[self navigationController] popViewControllerAnimated:YES];
#endif

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
	return [OhmAppearance nowPlayingViewControllerBackgroundColor];
}

- (UIStatusBarStyle) statusBarStyle
{
	return [OhmAppearance nowPlayingStatusBarStyle];
}

- (void) setStatusBarColor
{
	savedStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
	
	[[UIApplication sharedApplication] setStatusBarStyle:[self statusBarStyle] animated:YES];
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

- (UIImageView*) placeholderAirplayView
{
	UIImageView* imageView = nil;

	UIImage* image = [UIImage imageNamed:PLACEHOLDER_AIRPLAY_IMAGE];
	
	if (image)
	{
		imageView = [[UIImageView alloc] initWithImage:image];
	}
	
	return imageView;
}

- (void) setUpAirPlayControl
{
	UIView* parentView = self.airplayControllView;
	
	parentView.backgroundColor = [UIColor clearColor];
	
	MPVolumeView *controlView = [[MPVolumeView alloc] init];
	
	[controlView setShowsVolumeSlider:NO];
	[controlView setShowsRouteButton:YES];
	[controlView sizeToFit];
		
#if OHM_TARGET_SIMULATE
	
	// The MPVolumeView is not supported in the simulator, so we replace it with a placeholder
	// view to assist with visual layout.
	
	UIView* v = [self placeholderAirplayView];
	if (v) controlView = (MPVolumeView*)v;
#endif
		
	const CGFloat dx = parentView.frame.size.width	/ controlView.frame.size.width;
	const CGFloat dy = parentView.frame.size.height	/ controlView.frame.size.height;
	
	controlView.transform = CGAffineTransformMakeScale(dx, dy);

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

- (NSString*) currentSongIndexLabel
{
	const NSUInteger indexOfCurrentSong		= [[self musicPlayer] indexOfNowPlayingSong];
	
	if (indexOfCurrentSong == NSNotFound)	return nil;

	const NSUInteger countOfCurrentSongs	= [[self musicPlayer] countOfSongsInQueue];
	
	if (0 == countOfCurrentSongs)	return nil;
	
	return [NSString stringWithFormat:NSLocalizedString(@"%ld of %ld", @"<index of item> of <total item count>"), (long)indexOfCurrentSong + 1, (long)countOfCurrentSongs];
}

- (NSString*) formattedInterval:(NSTimeInterval)interval
{	
    // The individual date components should never be formatted as negatives
    // so we make sure to always calculate an absolute interval.
    // Callers can format "negative" intervals as needed.
    
    interval = fabs(interval);
    
	// Get the localized system calendar.
	NSCalendar *usersCalendar = [NSCalendar currentCalendar];

    NSDate *now     = [[NSDate alloc] init];
    NSDate *date    = [[NSDate alloc] initWithTimeInterval:interval sinceDate:now]; 

	// Breakdown into hours, minutes and seconds.
	NSCalendarUnit calendarUnits =  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	
	NSDateComponents *dateComponents = [usersCalendar components:calendarUnits fromDate:now toDate:date options:0];
    
	const NSInteger hour	= [dateComponents hour];
	const NSInteger minute	= [dateComponents minute];
	const NSInteger second	= [dateComponents second];
	
	NSString* timeStamp = nil;
    
	if (hour != 0)
	{
		timeStamp = [NSString stringWithFormat:@"%d:%2d:%02d", hour, minute, second];
	}
	else
	{
		timeStamp = [NSString stringWithFormat:@"%d:%02d", minute, second];
	}
	
	return timeStamp;
}

- (NSTimeInterval) elapsedTime
{
	// Note: on the device, the iPod music player will return NaN (Not a Nunber) for
	// the current playback time if music isn't playing...
	
	NSTimeInterval t =  [self musicPlayer].currentPlaybackTime;
	
	return isfinite(t) ? t : 0.0F;
}

- (void) setElapsedTime:(NSTimeInterval)elapsedTimeInSecs
{
	[self musicPlayer].currentPlaybackTime = isfinite(elapsedTimeInSecs) ? elapsedTimeInSecs : 0.0F;
}

- (NSTimeInterval) totalTime
{
	return [[self musicPlayer].nowPlayingSong.playbackDuration doubleValue];
}

- (BOOL) isNowPlaying
{
	return [self musicPlayer].nowPlayingSong != nil;
}

- (BOOL) userIsSlidingSliderWhileMusicIsPlaying
{
	return (playbackTimeSlider.isTracking) && [self isNowPlaying];
}

- (void) updatePlaybackSlider
{	
	if (![self userIsSlidingSliderWhileMusicIsPlaying])
	{
		[playbackTimeSlider setValue:(float)[self elapsedTime] animated:NO];
	}
}

- (void) updateCurrentPlaybackTimes
{
    const NSTimeInterval elapsedTime    = [self elapsedTime];
    const NSTimeInterval totalTime      = [self totalTime];
    const NSTimeInterval remainingTime  = elapsedTime - totalTime;
	
    // Elapsed time.
    
    timeElapsed.text = [self formattedInterval:elapsedTime];
    
    // Time remaining.
    
    {           
        NSString* formattedDate = [self formattedInterval:remainingTime];
        
		NSString* const Format = 
#if OHM_TARGET_4
		@"%@"; // Don't show negative sign for time remaining in Ohm4.
#else
		@"-%@";
#endif
		
        timeRemaining.text = (formattedDate) ? [NSString stringWithFormat:Format,formattedDate] : nil;
    }
    
    [self updatePlaybackSlider];
}

- (void) updateCurrentPlaybackTimesUnlessTracking
{
	if ([self userIsSlidingSliderWhileMusicIsPlaying]) return;
	
	[self updateCurrentPlaybackTimes];
}

- (UIImage*) songImage
{
	return [[self musicPlayer].nowPlayingSong imageWithSize:albumArtView.frame.size];
}

- (UIView*) viewWithReflectionForImageView:(UIImageView*)view
{
	if (!view) return nil;
	
	const CGFloat viewWidth = view.frame.size.width;
	const CGFloat viewHeight = view.frame.size.height;
	const CGFloat shadowPercent = 0.20F;
	const CGFloat reflectionOpacity = 0.54F;
	
	UIImageView* reflectionView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, viewWidth, viewHeight * shadowPercent)];

	reflectionView.image = [OhmAppearance reflectedImageFromUIImageView:view withHeight:(NSUInteger)reflectionView.frame.size.height];
	
	reflectionView.alpha = reflectionOpacity;
	
	UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0F, viewWidth, viewHeight + reflectionView.frame.size.height)];

	// Make sure view is at origin
	view.frame = CGRectMake(0.0F, 0.0F, view.frame.size.width, view.frame.size.height);
	reflectionView.frame = CGRectMake(0.0F,view.frame.size.height, viewWidth, reflectionView.frame.size.height);
			
	[container addSubview:view];
	[container addSubview:reflectionView];
	
	return container;
}

- (UIView*) songArtView
{	
	UIImage* image = [self songImage];
		
	UIImageView* imageView = (image) ? [[UIImageView alloc] initWithImage:image] : nil;
	
	imageView.frame = albumArtView.frame;
	
	return [self viewWithReflectionForImageView:imageView];
}

- (UIView*) placeHolderSongArtView
{	
	UIImage* image = [[UIImage imageNamed:PLACEHOLDER_ALBUM_IMAGE_NAME] copy];
	
	UIImageView* imageView = (image) ? [[UIImageView alloc] initWithImage:image] : nil;

	imageView.frame = albumArtView.frame;
	
	return [self viewWithReflectionForImageView:imageView];
}

- (void) updateCurrentPlayingItem
{
	Song* nowPlayingSong = [self musicPlayer].nowPlayingSong;
	
	albumTitle.text	= nowPlayingSong.albumName;
	artistName.text	= nowPlayingSong.artistName;
	songTitle.text	= nowPlayingSong.title;
    
	songNumber.text = [self currentSongIndexLabel];
	
	static const NSInteger ALBUM_IMAGE_VIEW_TAG = 10;
	
	if (nowPlayingSong)
	{
		playbackTimeSlider.maximumValue = [nowPlayingSong.playbackDuration floatValue];
		
		UIView* songArt = [self songArtView];
		
		if (!songArt)
		{
			songArt = [self placeHolderSongArtView];
		}
		
		if (songArt)
		{			
			songArt.frame = albumArtView.bounds;		
			songArt.tag = ALBUM_IMAGE_VIEW_TAG;
			
			UIView* previousView = [albumArtView viewWithTag:ALBUM_IMAGE_VIEW_TAG];
			
			if (previousView)
			{
				[UIView transitionFromView:previousView toView:songArt duration:0.0F options:UIViewAnimationOptionTransitionNone completion:nil];
			}
			else
			{
				[albumArtView addSubview:songArt];
			}
		}
		
		[self updateCurrentPlaybackTimes];
		
		// Note: we're using the iPod music player so we shouldn't have
		// to update the music info for Airplay...
	}
	else
	{
		// No song is playing. Reset state...
		
		playbackTimeSlider.value = 0.0F;
		
		[[albumArtView viewWithTag:ALBUM_IMAGE_VIEW_TAG] removeFromSuperview];
	}
}

- (void) setUpPlaybackUpdateTimer
{	
	// Set up a timer that fires once per second and calls this object's clock tick method
	// to simulate elapsed playback time.
	
	if (!playbackTimer)
	{
		playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0F /*secs*/ target:self selector:@selector(updateCurrentPlaybackTimesUnlessTracking) userInfo:nil repeats:YES];
	}
	
}

- (void) tearDownPlaybackUpdateTimer
{
	[playbackTimer invalidate]; playbackTimer = nil;
}

#pragma mark Protected Methods - Twitter Support

- (NSString*) truncateToTwitterPostLength:(NSString*)content // $$$$$ Not implemented
{
	return content; 
}

- (NSString*) twitterArtistFromSong:(Song*)song
{
    // In the future, we could lookup twitter handles by artist name and prepend
    // an @ symbol. For now, we just return the song's artist name as is.
    
    return song.artistName;
}

- (NSString*) titterNowPlayingFormat_title_artist
{
    // Note: the now playing format needs to be localized.
     
    return NSLocalizedString(@"#np %@ by %@ #ohm", @"#np %@ by %@ #ohm");
}

- (NSString*) twitterPostForSong:(Song*)song
{
    NSString* format_title_artist = [self titterNowPlayingFormat_title_artist];
    
	NSString* result = (song && format_title_artist) ? [NSString stringWithFormat:format_title_artist,
                                                        song.title,
                                                        [self twitterArtistFromSong:song]] : nil;
	
	return (result) ? [self truncateToTwitterPostLength:result] : nil;
}

- (NSString*) nowPlayingTweetContent
{	
	Song* nowPlayingSong = [self musicPlayer].nowPlayingSong;
	
#if 1
	return (nowPlayingSong) ? [self twitterPostForSong:nowPlayingSong] : nil;
#else
	// Note: if the code attempt to tweet content that's larger than the Twitter API will accept,
	// the code below demonstrates that Apple's Tweet Sheet will display an empty tweet.
	
	// In summary: it's our code's responsibility to make sure a tweet is suffiiently short...
	
	const int LEN = 1024; // Purposley too long for Twitter to handle.
	char s[LEN + 1];
	memset(s, 'a', LEN);
	
	return (nowPlayingSong) ? [NSString stringWithFormat:@"%s/%@",s, nowPlayingSong.title] : nil;
#endif
	
}

- (void) setUpRightNavigationBarButton
{	
#if OHM_TARGET_4
	id target			= self;
	const SEL action	= @selector(compose:);
	
	UIBarButtonItem* rightBarButtonItem = 
		[OhmBarButtonItems barButtonItemWithImageNamed:NAV_BAR_RIGHT_BUTTON_IMAGE target:target action:action];
	
	if (!rightBarButtonItem)
	{
		rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:target action:action];
	}
		
	if (rightBarButtonItem) [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
#endif
}

- (void) setUpNavigationBarAppearance
{
#if OHM_TARGET_4
	UIImage* image = [UIImage imageNamed:NAV_BAR_BACKGROUND_IMAGE];
	
	if (image)
	{
		UINavigationBar* navBar = self.navigationController.navigationBar;
		
		[navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
	}
#endif
}

- (void) setUpNavBar
{
	[self setUpNavigationBarAppearance];
	[self setUpRightNavigationBarButton];
}

#pragma mark UIViewController Methods

- (void) viewDidLoad
{	
	self.view.backgroundColor = [self backgroundColor];
	
	// Clear the placeholder text in the storyboard.
	
	albumTitle.text	= nil;
	artistName.text	= nil;
	songTitle.text	= nil;
	timeElapsed.text = nil;
	timeRemaining.text = nil;
    //[playbackTimeSlider setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    
	[self setUpAirPlayControl];
	[self setUpVolumeControl];
	
}

- (void) viewDidUnload
{
    [self setVolumeControlView:nil];
    [self setAirplayControllView:nil];
    [self setArtistName:nil];
    [self setAlbumTitle:nil];
    [self setSongTitle:nil];
    [self setAlbumArtView:nil];
    [self setTimeRemaining:nil];
    [self setTimeElapsed:nil];
    [self setSongNumber:nil];
    [self setPlaybackTimeSlider:nil];
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{	
	[self registerForNotifications];
	
	[self setColorScheme];
	
	[self updateCurrentPlayingItem];

	[self setUpNavBar];
	
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
	[self setUpPlaybackUpdateTimer];

	[super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
	[self tearDownPlaybackUpdateTimer];
	
	[super viewDidDisappear:animated];
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

- (IBAction)sliderDidChange:(UISlider*)sender
{	
	// This method is supposed to be called only when the value of the slider control changes.
	// Note however, it's called even when the value doesn't change (the user is holding still)
	// and also called when the user picks up their finger from the slider.
	
	// In the later case we should not set the playback time, instead let the slider resume to
	// the current playback position when it's next updated.
	
	if ([self userIsSlidingSliderWhileMusicIsPlaying])
	{
		const float newElapsedTimeInSecs = [sender value];

		[self setElapsedTime:newElapsedTimeInSecs];

		[self updateCurrentPlaybackTimes];
	}
}

- (IBAction)compose:(id)sender
{
    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:[self nowPlayingTweetContent]];
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        
		// We don't do anything with the result but the switch
		// is here just in case...
		
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                break;
            case TWTweetComposeViewControllerResultDone:
                break;
            default:
                break;
        }
                
        // Dismiss the tweet composition view controller. // Based on Apple Sample code, but still - is this safe to call from a background thread?
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [self presentModalViewController:tweetViewController animated:YES];
}

@end
