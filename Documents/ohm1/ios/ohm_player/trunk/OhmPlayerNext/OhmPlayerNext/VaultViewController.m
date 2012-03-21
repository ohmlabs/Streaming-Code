/*
 
 File: VaultViewController.m
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import "VaultViewController.h"

#import "VaultArtistIndexView.h"
#import "VaultArtistsView.h"
#import "VaultAlbumsView.h"
#import "VaultSongsTableViewController.h"

#import "MusicLibrary.h"

static NSString* NIB_NAME = @"VaultViewController";

@implementation VaultViewController

#pragma mark Properties - Synthesized

@synthesize artistsIndexView;
@synthesize artistsView;
@synthesize albumsView;
@synthesize songsTableView;
@synthesize albumTitleCell;

#pragma mark Properties

- (VaultSongsTableViewController*) songsTableViewController
{
	if (!songsTableViewController)
	{
		songsTableViewController = [[VaultSongsTableViewController alloc] initWithTableView:songsTableView];
	}
	
	return songsTableViewController;
}

- (void) setSongsTableViewController:(VaultSongsTableViewController *)aSongsTableViewController
{
	if (songsTableViewController != aSongsTableViewController)
	{
		[songsTableViewController release];
		songsTableViewController = [aSongsTableViewController retain];
	}
}

#pragma mark Protected Methods

- (MusicLibrary*) musicLibrary
{
	return musicLibrary();
}

- (NSArray*) artists
{
	return [[self musicLibrary] artists];
}

- (NSString*) artistForIndexCharacter:(unichar)c
{
	NSArray* artists = [[self musicLibrary] artists];
	
	// Note: the artist list is already sorted, hence binary searching is fast. This method returns the would-be insertion point
	// of a binary search if a match isn't found.

	NSUInteger i = [artists indexOfObject:[NSString stringWithCharacters:&c length:1] inSortedRange:NSMakeRange(0, [artists count]) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2){
			return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
				}];
		
	if (i >= [artists count])
	{
		return [artists lastObject];
	}
	
	return [artists objectAtIndex:i];
}

- (UIColor*) songsTableViewSeparatorColor
{
	return [UIColor darkGrayColor];
}

- (void) configureAlbumTitleCell
{	
	UIColor* textColor			= [UIColor whiteColor];
	UIColor* backgroundColor	= [UIColor clearColor];

	UITableViewCell* cell			= self.albumTitleCell;
	
	cell.textLabel.textColor		= textColor;
	cell.textLabel.backgroundColor	= backgroundColor;
	cell.textLabel.textAlignment	= UITextAlignmentCenter;
	cell.textLabel.lineBreakMode	= UILineBreakModeTailTruncation;
}

- (void) updateAlbumSongsView
{
	// This method is called by the albums view when the user taps an album.

	self.songsTableViewController.album		= albumsView.album;
	self.albumTitleCell.textLabel.text		= albumsView.album;
	
	NSLog(@"tapped album : %@", albumsView.album);

}

- (void) selectArtist:(NSString*)artist
{
	self.artistsView.artist					= artist;
	self.albumsView.artist					= artist;
	self.songsTableViewController.artist	= artist;
	
	[self updateAlbumSongsView];
}

- (void) handleIndexViewTouched:(VaultArtistIndexView*)sender
{
	// This method is called when the user touches in the artist index view.
	// It asks the sender for the selected character and updates the selected artist.
	
	NSAssert1([sender isKindOfClass:[VaultArtistIndexView class]], @"Unexpected class %@", [sender class]);
	
	const unichar c = [sender selectedChar];
	
	NSLog(@"selected char %C", c);
		
	[self selectArtist:[self artistForIndexCharacter:c]];
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	// This method is called whenever the artists or albums scroll view stops.
	
	if (scrollView == artistsView)
	{
		[self selectArtist:[artistsView artist]];
	}
	else if (scrollView == albumsView)
	{
		// By design, do nothing. The user can browse albums, but
		// nothing changes during album scrolling.
	}
	else
	{
		NSAssert1(NO, @"Unknown scroll view %@", scrollView);
	}
}

#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

	NSParameterAssert(artistsIndexView);
	NSParameterAssert(artistsView);
	NSParameterAssert(albumsView);
	NSParameterAssert(songsTableView);
	NSParameterAssert(albumTitleCell);
	
	// Listen for touches in the artist index view.
	[artistsIndexView addTarget:self action:@selector(handleIndexViewTouched:)];
	
	// Update the artists view.
	NSArray* artists = [self artists];
	
	[artistsView setArtists:artists];

	if ([artists count])
	{
		[self selectArtist:[artists objectAtIndex:0]];
	}
	
	// Customize the tableviews line color...
	
	songsTableView.separatorColor = [self songsTableViewSeparatorColor];
	
	[self configureAlbumTitleCell];
	
	[self updateAlbumSongsView];
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

#pragma mark Notification Handlers


- (void) handleImageCacheUpdate: (NSNotification *)notification
{	
	[[self albumsView] updateCells];
}

#pragma mark Notifications

- (void) registerForNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleImageCacheUpdate:)
												 name:MusicLibraryImageCacheUpdatedNotification
											   object:nil];
}

- (void) unregisterForNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Object Life Cycle

- (void) awakeFromNib
{
	[self registerForNotifications];
}

- (id) init // Designated initializer.
{
	return [self initWithNibName:NIB_NAME bundle:nil];
}

- (void)dealloc
{
	[self unregisterForNotifications];
	
	[artistsIndexView release];
	[artistsView release];
	[albumsView release];
	[songsTableViewController release];
	[songsTableView release];
	[albumTitleCell release];
	
    [super dealloc];
}

@end
