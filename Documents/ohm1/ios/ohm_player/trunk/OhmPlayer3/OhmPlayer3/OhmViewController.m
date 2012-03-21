//
//  OhmViewController.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "OhmViewController.h"

#import "WireViewProvider.h"
#import "MusicPlayer.h"
#import "NotificationListener.h"

@interface OhmViewController (ForwardDeclarations)

- (void) updatePostStatusLabel;
- (void) updateNowPlayingButton;

@end

const NSTimeInterval WIRE_VIEW_TRANSLATION_DURATION		= 0.30F;
const NSTimeInterval SET_WIRE_VIEW_TRANSITION_DURATION	= 0.15F;

@implementation OhmViewController

#pragma mark Properties

@synthesize wire;
@synthesize wireInspectorView;
@synthesize postStatusBar;
@synthesize postStatusLabel;
@synthesize postStatusButton;
@synthesize navigationButtonsArea;
@synthesize nowPlayingButton;

#pragma mark Protected Accessors

- (WireViewProvider*) wireViewProvider
{
	if (!wireViewProvider)
	{
		wireViewProvider = [[WireViewProvider alloc] init];
	}
	
	return wireViewProvider;
}

- (MusicPlayer*) musicPlayer
{
	return musicPlayer();
}

- (void) playbackDidChangeNotificationHandler:(NSNotification*)note
{
	[self updateNowPlayingButton];
}

#pragma mark Protected Methods - Notififcation Registration

- (void) registerForNotifications
{
	if (!playbackDidChangeListener)
	{
		playbackDidChangeListener = [[NotificationListener alloc] initWithTarget:self notificationHandler:@selector(playbackDidChangeNotificationHandler:) notificationName:MPMusicPlayerControllerPlaybackStateDidChangeNotification];
	}
	
}

- (void) unregisterForNotifications
{
	playbackDidChangeListener = nil;
}

#pragma mark UIViewController Methods

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self registerForNotifications];
	
	[self updateNowPlayingButton];

	[self updatePostStatusLabel];
}

- (void) viewWillDisappear:(BOOL)animated
{
	[self unregisterForNotifications];
	
	[super viewWillDisappear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void) viewDidLoad
{
	// The right bar button item is set in the storyboard (and has a segue) but we don't
	// want it to initially show it when the view is loaded.
	
	[self.navigationItem setRightBarButtonItem:nil animated:NO];
}

- (void) viewDidUnload
{
	[self setWire:nil];
	[self setWireInspectorView:nil];
	[self setPostStatusBar:nil];
	[self setPostStatusLabel:nil];
	[self setPostStatusButton:nil];
	[self setNavigationButtonsArea:nil];
	[self setNowPlayingButton:nil];
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	static NSString* const SIGN_IN_SEGUE = @"signIn";
	
	if ([[segue identifier] isEqualToString:SIGN_IN_SEGUE])
	{
		SignInViewController* vc = [segue destinationViewController];
		vc.delegate = self;
	}
	
}

#pragma mark SignInViewControllerDelegate Methods

- (void)done:(SignInViewController*)signInViewController
{
	NSParameterAssert(signInViewController);
	
	[signInViewController dismissViewControllerAnimated:YES completion:NULL];
	 
}

#pragma mark Protected Methods

- (void) updateNowPlayingButton
{
	// Note: we can't simply hide the bar button item because it's not a subclass of UIView.
	// Instead we have to replace it. Note: it has a segue in the storyboard
	// attached to it that we want to preserve.
			
	UIBarButtonItem* rightButton = (![[self musicPlayer] isStopped]) ? nowPlayingButton : nil;
		
	[self.navigationItem setRightBarButtonItem:rightButton animated:YES];
}

- (void) updatePostStatusLabel
{
	// $$$$$ Do we show the total number of posts in the wire, or just the unseen posts?
	
	const NSUInteger NumPosts = ([[self wireViewProvider] numberOfColumnsInWire]);
	
	NSString* localizedString = NSLocalizedString(@"New Media", @"New Media");
	
	if (!localizedString)
	{
		localizedString = @"New Media";
	}
	
	NSString* formattedText = [NSString stringWithFormat:@"%ld %@", (long)NumPosts, localizedString];
	
	if (!formattedText)
	{
		formattedText = @"New Media";
	}
	
	postStatusLabel.text = formattedText;
}

- (CGFloat) heightOfWire
{
	return wire.frame.size.height;
}

- (CGFloat) heightOfPostStatusBar
{
	return postStatusBar.frame.size.height;
}

- (CGFloat) heightAboveWire
{
	return (self.view.frame.size.height - [self heightOfWire]);
}

-(void) verticallyTranslateView:(UIView*)view offsetY:(const CGFloat)dy
{	
	view.frame = CGRectOffset(view.frame, 0.0F, dy);
}

- (void) translateWireInspector:(const CGFloat)translation
{	
	[UIView animateWithDuration:WIRE_VIEW_TRANSLATION_DURATION animations:^{
						
		[self verticallyTranslateView:navigationButtonsArea offsetY:translation];

		[self verticallyTranslateView:postStatusBar offsetY:translation];
		
		[self verticallyTranslateView:postStatusLabel offsetY:translation];
		
		[self verticallyTranslateView:wireInspectorView offsetY:translation];

	}];
}

- (BOOL) isShowingWireInspector
{
	// We assume the wire inspector is shown if the navigation bar is hidden.
	
	return [[self navigationController] isNavigationBarHidden];
}

- (CGFloat) distanceToShowWireInspector
{
	// Move the post status bar to the top of the screen
	// by reducing its y ordinate to 0.
	
	return -postStatusBar.frame.origin.y;
}

- (CGFloat) distanceToHideWireInspector
{
	// Traverse the distance above the wire, but leave room
	// for the status bar to remain displayed.
	
	return [self heightAboveWire] - [self heightOfPostStatusBar];
}

- (void) showWireInspector
{	
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	
	postStatusButton.title = NSLocalizedString(@"Hide", @"Hide");
	
	[self translateWireInspector: [self distanceToShowWireInspector]];
}

- (void) hideWireInspector
{	
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	
	postStatusButton.title = NSLocalizedString(@"Show", @"Show");

	[self translateWireInspector: [self distanceToHideWireInspector] ];
}

- (void) setSizeForWireCell:(UIView*)cell
{
	const CGFloat Side = [self heightOfWire];
	
	cell.frame = CGRectMake(0.0F, 0.0F, Side, Side);
}

- (BOOL) isNavigationBarShowing
{
	return [[self navigationController] isNavigationBarHidden];
}

- (void) setSizeForWireView:(UIView*)view
{
	UIView* targetView = wireInspectorView;
	
	const CGFloat height	= targetView.frame.size.height;
	const CGFloat width		= targetView.frame.size.width;
	
	view.frame = CGRectMake(0, 0, width, height);
}

- (void) setWireView:(UIView*)newView
{
	NSParameterAssert(newView);
	
	// Note: we don't want the wire view's tag value to collide with
	// the a wire cell's tag value, so we choose a large value that a
	// cell should never have.
	
	UIView* targetView = wireInspectorView;
	
	static const NSInteger WIRE_VIEW_TAG = NSIntegerMax;
	
	newView.tag = WIRE_VIEW_TAG;
	
	UIView* existingView = [targetView viewWithTag:WIRE_VIEW_TAG];
	
	if (newView && existingView)
	{
		[UIView transitionFromView:existingView toView:newView duration:SET_WIRE_VIEW_TRANSITION_DURATION options:(UIViewAnimationOptionTransitionCrossDissolve) completion:NULL];
	}
	else if (newView)
	{		
		[targetView addSubview:newView];
	}
}

- (void) selectFirstItemInWire
{
	if ([[self wireViewProvider] numberOfColumnsInWire])
	{
		[self gallery:self.wire didSelectColumnAtIndex:0];
	}
}

#pragma mark GalleryViewDelegate Methods

- (void) gallery:(GalleryView*)gallery didSelectColumnAtIndex:(NSUInteger)index
{
	UIView* view =  [[self wireViewProvider] wireViewForColumnAtIndex:index];
	
	if (view)
	{
		[self setSizeForWireView:view];
		
		[self setWireView:view];
		
		if (![self isShowingWireInspector])
		{
			[self showWireInspector];
		}
	}
	
}

- (BOOL) shouldEnablePagingForGallery:(GalleryView*)gallery
{
	return NO;
}

#pragma mark GalleryViewDataSource Methods

- (NSUInteger) numberOfColumnsInGallery:(GalleryView*)gallery
{
	return [[self wireViewProvider] numberOfColumnsInWire];
}

- (id) gallery:(GalleryView*)gallery cellForColumnAtIndex:(NSUInteger)index
{
	UIView* cell = [[self wireViewProvider] wireCellForColumnAtIndex:index];
	
	if (cell) [self setSizeForWireCell:cell];
	
	return cell;
}

#pragma mark Actions

- (IBAction)toggleWirePostView:(id)sender
{
	if ([self isShowingWireInspector])
	{
		[self hideWireInspector];
	}
	else
	{
		[self showWireInspector];
	}
}

@end
