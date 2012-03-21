//
//  PlaylistsViewController.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "PlaylistsViewController.h"

#import <QuartzCore/QuartzCore.h> // For CALayer access...

#import "MusicLibrary.h"
#import "MusicPlayer.h"
#import "OhmPlaylistManager.h"
#import "OhmAppearance.h"
#import "OhmBarButtonItems.h"
#import "AppState.h"

static NSString* const PLAYLIST_SONG_CELL_REUSE_ID		= @"PlaylistCell";
static NSString* const PLAYLIST_HEADER_VIEW				= @"ReadOnlyPlaylistHeaderView";
static NSString* const OHM_PLAYLIST_HEADER_VIEW			= @"OhmPlaylistHeaderView";

static NSString* const NAV_BAR_BACKGROUND_IMAGE			= @"nav_bar_banner";
static NSString* const NAV_BAR_RIGHT_BUTTON_IMAGE		= @"music_btn_up";
static NSString* const NAV_BAR_LEFT_BUTTON_IMAGE		= @"back_btn_up";

static NSString* const PLAYLIST_VIEW_STATE_SELECTED_PLAYLIST_INDEX	= @"PLAYLIST_VIEW_STATE_SELECTED_PLAYLIST_INDEX";
static NSString* const SEGUE_FROM_PLAYLISTS_TO_MUSIC_SCREEN_ID		= @"PlaylistsToMusicSegue";

@implementation PlaylistsViewController

#pragma mark Properties

@synthesize wire;
@synthesize tableView;
@synthesize playlistHeaderView;
@synthesize ohmPlaylistHeaderView;

#pragma mark Protected Methods

- (MusicLibrary*) musicLibrary
{
	return musicLibrary();
}

- (MusicPlayer*) musicPlayer
{
	return musicPlayer();
}

- (NSArray*) ohmPlaylists
{
#if OHM_TARGET_4
	
	// Note: the Ohm Queue appears on a separate screen in Ohm4.
	
    // $$$$$ we need to ask the OhmPlaylistManager for persistent playlists!
    
	return nil;
#else
	id queue = [OhmPlaylistManager queue];
	
	return (queue) ? [NSArray arrayWithObject:queue] : nil;
#endif
}

- (NSArray*) musicLibraryPlaylists
{
	return [[self musicLibrary] allITunesPlaylists];
}

- (UIColor*) tableViewBackgroundColor
{
	return [OhmAppearance playlistTableViewBackgroundColor];
}

- (NSArray*) playlists
{
	if (!compositePlaylists)
	{
		NSArray* ohmLists		= [self ohmPlaylists];
		NSArray* libraryLists	= [self musicLibraryPlaylists];
				
		if (ohmLists && libraryLists)
		{
			compositePlaylists = [ohmLists arrayByAddingObjectsFromArray:libraryLists];
		}
		else if (!libraryLists)
		{
			compositePlaylists = ohmLists;
		}
		else if (!ohmLists)
		{
			compositePlaylists = libraryLists;
		}
		
		// $$$$$ ISSUE: sort the composite list by name (?)!
	}
	
	return compositePlaylists;
}



- (UITableViewCell*) tableViewCell
{
	return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PLAYLIST_SONG_CELL_REUSE_ID];
}

- (UIView*) genericCell:(NSString*)labelText
{
	if (!labelText) return nil;
	
				NSString*	CELL_FONTNAME		= [OhmAppearance defaultFontName];
	static const CGFloat	CELL_FONTSIZE		= 30.0F;
	static const CGFloat	CELL_FONTSIZE_MIN	= 10.0F;
	static		UIFont*		font = nil;
	
	if (!font)
	{
		font = [UIFont fontWithName:CELL_FONTNAME size:CELL_FONTSIZE];
	}
	
	NSParameterAssert([labelText length]);
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
	UIColor* textColor			= [UIColor whiteColor];
	
#if OHM_TARGET_4
	UIColor* backgroundColor	= [UIColor grayColor];
#else
	UIColor* backgroundColor	= [UIColor lightGrayColor];
#endif
	
	label.text					= labelText;
	label.font					= font;
	label.textColor				= textColor;
	label.backgroundColor		= backgroundColor;
	label.textAlignment			= UITextAlignmentCenter;
	label.lineBreakMode			= UILineBreakModeTailTruncation;
	label.minimumFontSize		= CELL_FONTSIZE_MIN;
		
	[label.layer setBorderColor:[UIColor darkGrayColor].CGColor];
	[label.layer setBorderWidth:1.0F];

	label.adjustsFontSizeToFitWidth = YES;
	[label sizeToFit];
	
	const CGFloat Side = 44.0F;
	
	label.frame = CGRectMake(0.0F, 0.0F, Side, Side);
	
	return label;
}

- (CGFloat) heightOfWire
{
	return wire.frame.size.height;
}

- (void) setSizeForWireCell:(UIView*)cell
{
	const CGFloat Side = [self heightOfWire];
	
	cell.frame = CGRectMake(0.0F, 0.0F, Side, Side);
}

- (void) configureWireCell:(id)cell
{
	[self setSizeForWireCell:cell];
}

- (void) configureCell:(UITableViewCell*)cell forSong:(Song*)song
{	
	if ([[self musicPlayer] isPlayingSong:song])
	{
		cell.textLabel.textColor = [UIColor lightGrayColor];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	else
	{
		cell.textLabel.textColor = [UIColor darkTextColor];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	cell.textLabel.text = song.title;
	
	const CGSize imageSize = CGSizeMake(cell.frame.size.height, cell.frame.size.height);
	
	cell.imageView.image = [song imageWithSize:imageSize];

	NSString* albumAndArtist = nil;
	
	if (song.artistName && song.albumName)
	{
		albumAndArtist = [NSString stringWithFormat:@"%@ - %@", song.albumName, song.artistName];
	}
	else if (song.artistName)
	{
		albumAndArtist = [NSString stringWithFormat:@"%@", song.artistName];
	}
	else if (song.albumName)
	{
		albumAndArtist = [NSString stringWithFormat:@"%@", song.albumName];
	}
	
	cell.detailTextLabel.text = albumAndArtist;

}

- (Playlist*) selectedPlaylist
{
	return selectedPlaylist;
}

- (void) setSelectedPlaylist:(Playlist*)playlist
{
	selectedPlaylist = playlist;
	
	if (selectedPlaylist)
	{
		self.tableView.tableHeaderView = (selectedPlaylist.readonly) ? [self playlistHeaderView] : [self ohmPlaylistHeaderView];
	}
	else
	{
		self.tableView.tableHeaderView = nil;
	}
}

- (NSArray*) songs
{
	return [[self selectedPlaylist] songs];
}

- (MusicLibrarySong*) songForIndexPath:(NSIndexPath*)indexPath
{
	const NSInteger row = [indexPath row];
	
	return (row >= 0) ? [[self songs] objectAtIndex:row] : nil;
}

- (void) playSongInTableView:(UITableView*)aTableView atIndexPath:(NSIndexPath*)indexPath
{	
	MusicLibrarySong* song = [self songForIndexPath:indexPath];
	
	if (song && [self selectedPlaylist])
	{
		[[self musicPlayer] playSong:song inCollection:[self selectedPlaylist]];
		
		// Reload/redraw just the selected cell.
		
		NSArray* paths = [[NSArray alloc] initWithObjects:indexPath, nil];
		[aTableView reloadRowsAtIndexPaths:paths withRowAnimation:NO];
	}
}

- (void) setSavedPlaylistIndex:(NSUInteger)i
{
	[appState() setValue:[NSNumber numberWithUnsignedInteger:i] forKey:PLAYLIST_VIEW_STATE_SELECTED_PLAYLIST_INDEX];
}

- (NSUInteger) savedPlaylistIndex
{
	return [[appState() valueForKey:PLAYLIST_VIEW_STATE_SELECTED_PLAYLIST_INDEX] unsignedIntegerValue];
}

- (void) selectPlaylistAtIndex:(NSUInteger)i
{
    NSArray* playlists = [self playlists];
    
    if ([playlists count])
    {
        [self setSelectedPlaylist:[playlists objectAtIndex:i]];
	}
    
	[[self tableView] reloadData];
}

- (void) segueToNowPlayingScreen
{
#if OHM_TARGET_4
	[[self navigationController] popViewControllerAnimated:YES];
#else
	[self performSegueWithIdentifier:SEGUE_FROM_GALLERY_TO_NOW_PLAYING_ID sender:self];
#endif
}

#pragma mark Protected Methods - NavigationBar Setup

- (void) setUpNavigationBarAppearance
{
#if OHM_TARGET_4
	UIImage* image = [UIImage imageNamed:NAV_BAR_BACKGROUND_IMAGE];
	
	if (image)
	{
		UINavigationBar* navBar = self.navigationController.navigationBar;
		
		[navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
				
		[navBar setTitleTextAttributes:[OhmAppearance defaultNavBarTextAttributes]];
	}
#endif
}

- (void) setUpRightNavigationBarButton
{	
#if OHM_TARGET_4
	id target						= self;
	const SEL action				= @selector(segueToMusicScreen:);
	NSString* const	IMAGE_NAME		= NAV_BAR_RIGHT_BUTTON_IMAGE;
	
	UIBarButtonItem* barButtonItem = [OhmBarButtonItems barButtonItemWithImageNamed:IMAGE_NAME target:target action:action];
	
	if (barButtonItem) 
	{
		[self.navigationItem setRightBarButtonItem:barButtonItem];
	}
#endif
}

- (void) setUpLeftNavigationBarButton
{	
#if OHM_TARGET_4
	id target						= self;
	const SEL action				= @selector(back:);
	NSString* const	IMAGE_NAME		= NAV_BAR_LEFT_BUTTON_IMAGE;
	
	UIBarButtonItem* barButtonItem = [OhmBarButtonItems barButtonItemWithImageNamed:IMAGE_NAME target:target action:action];
	
	if (barButtonItem) 
	{
		[self.navigationItem setLeftBarButtonItem:barButtonItem];
	}
#endif
}

- (void) setUpNavBar
{
	[self setUpNavigationBarAppearance];
	[self setUpRightNavigationBarButton];
	[self setUpLeftNavigationBarButton];
}

#pragma mark GalleryView Datasource Methods

- (NSUInteger) numberOfColumnsInGallery:(GalleryView*)gallery
{
	// Note: this will be the total number of apple and ohm playlists.
	
	return [[self playlists] count];
}

- (id) gallery:(GalleryView*)gallery cellForColumnAtIndex:(NSUInteger)index
{
	// ISSUE: we should be reusing cells!
	
	Playlist* playlist = [[self playlists] objectAtIndex:index];
	
	UIView* cell = [self genericCell:playlist.name];
	
	if (cell)
	{
		[self configureWireCell:cell];
	}
	
	return cell;
}

#pragma mark GalleryView Delegate Methods

- (void) gallery:(GalleryView*)gallery didSelectColumnAtIndex:(NSUInteger)index
{
	[self selectPlaylistAtIndex:index];	
}

- (BOOL) shouldEnablePagingForGallery:(GalleryView*)gallery
{
	return NO;
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self selectedPlaylist] count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:PLAYLIST_SONG_CELL_REUSE_ID];
	if (!cell)
	{
		cell = [self tableViewCell];
	}
	
	// Configure the cell...
	
	NSArray* songs = [self songs];
	
	const NSInteger row = [indexPath row];
	
	MusicLibrarySong* song = (row >=0) ? [songs objectAtIndex:row] : nil;
	
	if (song)
	{
		[self configureCell:cell forSong:song];
		cell.accessoryView.tag = row; // IMPORTANT: Tag the accessory view so we can quickly determine its row later...
	}
	
	return cell;
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
	
	[self playSongInTableView:aTableView atIndexPath:indexPath];

#if OHM_TARGET_4
	// We have to manually segue to the Ohm/Now Playing screen. Otherwise, the segue is already setup in the storyboard.
	
	[self segueToNowPlayingScreen];
#endif
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIColor* backgroundColor = [self tableViewBackgroundColor];

	if (backgroundColor)
	{
		cell.backgroundColor = backgroundColor;
	}
	
}

#pragma mark UIViewController Methods

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
		
	[self selectPlaylistAtIndex:[self savedPlaylistIndex]];
}

-(void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[self setSavedPlaylistIndex:wire.selectedIndex];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	
	UIColor* color = [self tableViewBackgroundColor];
	
	if (color)
	{
		wire.backgroundColor = color;
		tableView.backgroundColor = color;
		playlistHeaderView.backgroundColor = color;
		ohmPlaylistHeaderView.backgroundColor = color;
	}
	
	[self setUpNavBar];
	
	NSParameterAssert(wire);
}

- (void) viewDidUnload
{
	[self setWire:nil];
	[self setTableView:nil];
	[self setPlaylistHeaderView:nil];
	[self setOhmPlaylistHeaderView:nil];
	
	compositePlaylists = nil;
	
	[super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Actions

- (IBAction) editPlaylist:(id)sender
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (IBAction) copyPlaylist:(id)sender
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (IBAction) deletePlaylist:(id)sender
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (IBAction) clearPlaylist:(id)sender
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (IBAction) shufflePlaylist:(id)sender
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (IBAction)segueToMusicScreen:(id)sender
{
	[self performSegueWithIdentifier:SEGUE_FROM_PLAYLISTS_TO_MUSIC_SCREEN_ID sender:self];
}

- (IBAction)back:(id)sender
{
	[[self navigationController] popViewControllerAnimated:YES];
}

@end
