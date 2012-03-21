//
//  OhmViewController.m
//  OhmPlayer4
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "OhmViewController.h"

#import "PlaylistThemesViewController.h"

static NSString* const SEGUE_FROM_OHM_TO_PLAYLISTTHEMES = @"ohm_to_themes";

@implementation OhmViewController

#pragma mark UIViewController Methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{	
	// For some reason, we can't set the PlaylistThemesViewController's delegate in the storyboard,
	// so we set it here..

	if ([[segue identifier] isEqualToString:SEGUE_FROM_OHM_TO_PLAYLISTTHEMES])
	{
		PlaylistThemesViewController* vc = [segue destinationViewController];
		vc.delegate = self;
	}
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark PlaylistThemesViewControllerDelegate Methods

// This delegate callback allows the modal PlaylistThemesViewController to dismiss itself.

- (void)done:(PlaylistThemesViewController*)playlistThemesViewController
{
	NSParameterAssert([playlistThemesViewController isKindOfClass:[PlaylistThemesViewController class]]);
	
	[playlistThemesViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
