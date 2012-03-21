//
//  GalleryListViewController.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "GalleryListViewController.h"

#import <MediaPlayer/MediaPlayer.h>

#import "GalleryViewController.h"
#import "AlbumsTableViewDataSource.h"
#import "ArtistsTableViewDataSource.h"
#import "SongsTableViewDataSource.h"
#import "SongsTableViewSupport.h"
#import "MusicLibrary.h"
#import "MusicPlayer.h"
#import "MutablePlaylist.h"
#import "Song.h"
#import "OhmPlaylistManager.h"
#import "OhmBarButtonItems.h"
#import "OhmAppearance.h"
#import "NotificationListener.h"
#import "AppState.h"

#import "OhmTargetConditionals.h"

// IMPORTANT: These indexes must match those in the corresponding storyboard.

enum {ARTISTS_TAB_INDEX = 0, ALBUMS_TAB_INDEX = 1 , SONGS_TAB_INDEX = 2};

static NSString* const CELL_SEGUE_TO_GALLERY						= @"CellSegueToGallery";
static NSString* const GALLERY_LISTVIEW_STATE_SELECTED_TAB_INDEX	= @"GALLERY_LIST_VIEW_STATE_SELECTED_TAB_INDEX";

static NSString* const NAV_BAR_LEFT_BUTTON_IMAGE					= @"back_btn_up";

#if !OHM_TARGET_4
static NSString* const SEGUE_FROM_GALLERY_LIST_TO_NOW_PLAYING_ID	= @"GalleryListToNowPlaying";
#endif

static const CGFloat SHUFFLE_ALL_FONT_SIZE			= 36.0F;

static const CGFloat DEFAULT_TABLEVIEWCELL_HEIGHT	= 44.0F;

@interface GalleryListViewController (ForwardDeclarations)

- (BOOL) albumDataSourceIsSelected;

@end

@implementation GalleryListViewController

#pragma mark Properties

@synthesize tabBar;
@synthesize tableView;

#pragma mark Accessors

- (NSObject<UITableViewDataSource, UITableViewDelegate>*) albumsTableViewDataSource
{
	if (!albumsTableViewDataSource)
	{
		albumsTableViewDataSource = [[AlbumsTableViewDataSource alloc] init];
	}
	
	return albumsTableViewDataSource;
}

- (NSObject<UITableViewDataSource, UITableViewDelegate>*) artistsTableViewDataSource
{
	if (!artistsTableViewDataSource)
	{
		artistsTableViewDataSource = [[ArtistsTableViewDataSource alloc] init];
	}
	
	return artistsTableViewDataSource;
}

- (NSObject<UITableViewDataSource, UITableViewDelegate>*) songsTableViewDataSource
{
	if (!songsTableViewDataSource)
	{
		songsTableViewDataSource = [[SongsTableViewDataSource alloc] init];
	}
	
	return songsTableViewDataSource;
}

- (SongsTableViewSupport*) songsTableViewSupport
{
	if (!songsTableViewSupport)
	{
		songsTableViewSupport = [[SongsTableViewSupport alloc] init];
	}
	
	return songsTableViewSupport;
}

#pragma mark Protected Methods - Notififcation Handling

- (void) nowPlayingSongDidChangeNotificationHandler:(NSNotification*)note
{
	[self.tableView reloadData];
}

- (void) imageCachedDidChangeNotificationHandler:(NSNotification*)note
{
	// Only the albums table view shows artwork, so if we get a stray notification
	// that the image cache has changed, we ignore it for non-ablum table views.
	
	if ([self albumDataSourceIsSelected])
	{
		[self.tableView reloadData];
	}
}

#pragma mark Protected Methods - Notififcation Registration

- (void) registerForNotifications
{
	if (!nowPlayingItemDidChangeNotificationListener)
	{
		nowPlayingItemDidChangeNotificationListener = [[NotificationListener alloc] initWithTarget:self notificationHandler:@selector(nowPlayingSongDidChangeNotificationHandler:) notificationName:MPMusicPlayerControllerNowPlayingItemDidChangeNotification];
	}
	
	if (!imageCacheDidChangeNotificationListener)
	{
		imageCacheDidChangeNotificationListener = [[NotificationListener alloc] initWithTarget:self notificationHandler:@selector(imageCachedDidChangeNotificationHandler:) notificationName:MusicLibraryImageCacheDidChangeNotification];
	}

}

- (void) unregisterForNotifications
{
	nowPlayingItemDidChangeNotificationListener = nil;
	imageCacheDidChangeNotificationListener = nil;
}

#pragma mark Protected Methods

- (MusicPlayer*) musicPlayer
{
	return musicPlayer();
}

- (MusicLibrary*) musicLibrary
{
	return musicLibrary();
}

- (NSUInteger) selectedTabBarIndex
{
	return [[tabBar items] indexOfObject:[tabBar selectedItem]];
}

- (void) selectTabBarButtonAtIndex:(NSUInteger)i
{
	if (i < [[tabBar items] count])
	{	
		tabBar.selectedItem = [[tabBar items] objectAtIndex:i];
#if OHM_TARGET_4
#else
		self.title = tabBar.selectedItem.title;
#endif
	}
}

- (NSObject<UITableViewDataSource, UITableViewDelegate>*) currentTableViewDataSource
{
	NSObject<UITableViewDataSource, UITableViewDelegate>* dataSource = nil;
	
	const NSUInteger i = [self selectedTabBarIndex];
	
	switch (i) {
		case ALBUMS_TAB_INDEX:
			dataSource = [self albumsTableViewDataSource];
			break;
						
		case SONGS_TAB_INDEX:
			dataSource = [self songsTableViewDataSource];
			break;
			
		case ARTISTS_TAB_INDEX:
		default:
			dataSource = [self artistsTableViewDataSource];
			break;
	}
	
	return dataSource;
}

- (void) setSelectedTableViewDataSource
{
	selectedTableViewDataSource = [self currentTableViewDataSource];
}

- (NSObject<UITableViewDataSource, UITableViewDelegate>*) selectedTableViewDataSource
{	
	return (selectedTableViewDataSource) ? selectedTableViewDataSource : [self currentTableViewDataSource];
}

- (NSUInteger) savedSelectedTabIndex
{
	return [[appState() valueForKey:GALLERY_LISTVIEW_STATE_SELECTED_TAB_INDEX] unsignedIntegerValue];
}

- (void) setSavedSelectedTabIndex:(NSUInteger)index
{
	[appState() setValue:[NSNumber numberWithUnsignedInteger:index] forKey:GALLERY_LISTVIEW_STATE_SELECTED_TAB_INDEX];
}

- (MusicLibrarySong*) songForIndexPath:(NSIndexPath*)indexPath
{
	return [[[self musicLibrary] allSongs] objectAtIndex:[indexPath row]];
}

- (void) queueSongInTableView:(UITableView*)aTableView atIndexPath:(NSIndexPath*)indexPath
{	
	MusicLibrarySong* song = [self songForIndexPath:indexPath];
		
	if (song)
	{
		[[OhmPlaylistManager queue] addSong:song];

		// Reload/redraw just the selected cell.
		
		NSArray* paths = [[NSArray alloc] initWithObjects:indexPath, nil];
		[tableView reloadRowsAtIndexPaths:paths withRowAnimation:NO];
	}
}

- (void) playSongInTableView:(UITableView*)aTableView atIndexPath:(NSIndexPath*)indexPath
{	
	MusicLibrarySong* song = [self songForIndexPath:indexPath];
		
	if (song)
	{
		[[self musicPlayer] playSong:song inCollection:[self musicLibrary]];
		
		// Reload/redraw just the selected cell.
		
		NSArray* paths = [[NSArray alloc] initWithObjects:indexPath, nil];
		[aTableView reloadRowsAtIndexPaths:paths withRowAnimation:NO];
	}
}

- (BOOL) artistDataSourceIsSelected
{
	return [self selectedTableViewDataSource] == artistsTableViewDataSource;
}

- (BOOL) albumDataSourceIsSelected
{
	return [self selectedTableViewDataSource] == albumsTableViewDataSource;
}

- (BOOL) songDataSourceIsSelected
{
	return [self selectedTableViewDataSource] == songsTableViewDataSource;
}

- (NSString*) albumName
{
	UITableViewCell* cell = [albumsTableViewDataSource tableView:tableView cellForRowAtIndexPath:[tableView indexPathForSelectedRow]];
	
	return cell.textLabel.text;
}

- (NSString*) artistName
{
	if ([self albumDataSourceIsSelected])
	{
		UITableViewCell* cell = [albumsTableViewDataSource tableView:tableView cellForRowAtIndexPath:[tableView indexPathForSelectedRow]];
		
		return cell.detailTextLabel.text;
	}
	else if ([self artistDataSourceIsSelected])
	{
		UITableViewCell* cell = [artistsTableViewDataSource tableView:tableView cellForRowAtIndexPath:[tableView indexPathForSelectedRow]];
		
		return cell.textLabel.text;
	}
	
	return nil;
}

- (UIView*) songsTableHeaderView
{
	UIButton* headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	headerButton.frame = CGRectMake(0, 0, tableView.frame.size.width, DEFAULT_TABLEVIEWCELL_HEIGHT);
	
	[headerButton setTitle:NSLocalizedString(@"Shuffle All", @"Shuffle All") forState:UIControlStateNormal];
	[headerButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
		
	headerButton.titleLabel.font = [UIFont boldSystemFontOfSize: SHUFFLE_ALL_FONT_SIZE];
	
	[headerButton addTarget:self action:@selector(shuffleAll) forControlEvents:UIControlEventTouchUpInside];
	
	return headerButton;
}

- (void) segueToNowPlayingScreen
{
#if OHM_TARGET_4
	[[self navigationController] popViewControllerAnimated:YES];
#else
	[self performSegueWithIdentifier:SEGUE_FROM_GALLERY_LIST_TO_NOW_PLAYING_ID sender:self];
#endif
}

- (void) setUpRightNavigationBarButton
{	
	// ISSUE: Do nothing until we get an asset (?)
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
	[self setUpRightNavigationBarButton];
	[self setUpLeftNavigationBarButton];
}

#pragma mark UIViewController Methods

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewWillAppear:(BOOL)animated
{
	// Restore the saved tab index.
	
	[self registerForNotifications];

	NSUInteger i = [self savedSelectedTabIndex];
	
	[self selectTabBarButtonAtIndex:i];
	
	[tableView reloadData];
	
	[self setUpNavBar];

	[super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
	[self unregisterForNotifications];

	[super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
	// Save the current tab index so we can return to the same tab later.
	
	[self setSavedSelectedTabIndex:[self selectedTabBarIndex]];
	
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
	[self setTabBar:nil];
	[self setTableView:nil];
	
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
	// Note: there are multiple identical segues from cells to the gallery view in the storyboard.
	// Since seques must have unique IDs, we must check for a common ID prefix so
	// they can be treated identically.
	
	if ([[segue identifier] hasPrefix:CELL_SEGUE_TO_GALLERY])
	{
		GalleryViewController* vc = [segue destinationViewController];

		if ([self artistDataSourceIsSelected])
		{
			[vc selectArtistWithName:[self artistName]];
		}
		else if ([self albumDataSourceIsSelected])
		{
			[vc selectAlbumWithName:[self albumName] andArtistsName:[self artistName]];
		}
		
	}
	
}

#pragma mark UITabBarDelegate Methods

- (void)tabBar:(UITabBar *)aTabBar didSelectItem:(UITabBarItem *)item
{
#if OHM_TARGET_4
#else
	self.title = item.title;
#endif
	
	[self setSelectedTableViewDataSource];
	
	if ([self songDataSourceIsSelected])
	{		
		tableView.tableHeaderView = [self songsTableHeaderView];
	}
	else
	{
		if (tableView.tableHeaderView) tableView.tableHeaderView = nil;
	}
	
	[tableView reloadData];
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return [[self selectedTableViewDataSource] numberOfSectionsInTableView:aTableView];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
	return [[self selectedTableViewDataSource] tableView:aTableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
	UITableViewCell* cell = [[self selectedTableViewDataSource] tableView:aTableView cellForRowAtIndexPath:indexPath];
	
	if ([self songDataSourceIsSelected])
	{
		MusicLibrarySong* song = [self songForIndexPath:indexPath];
		
		UIColor* textColor = ([[OhmPlaylistManager queue] containsSong:song]) ? [OhmAppearance queuedSongTableViewTextColor] : [OhmAppearance songTableViewTextColor];
		
		cell.textLabel.textColor = textColor;

		if ([[self musicPlayer] isPlayingSong:song])
		{
			cell.accessoryView = nil;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else
		{
			cell.accessoryView = [[self songsTableViewSupport] accessoryButtonViewWithTarget:self];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
		cell.accessoryView.tag = [indexPath row]; // IMPORTANT: Tag the *accessory view* so we can quickly determine its row later...
	}
	
	return cell;
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
	
	// UX DESIGN: If the user wants to merely add a song to the queue without preempting the currently
	// playing song (if any) they need to tap the + button. Note: tapping the + button
	// will call this controller's addSongButtonTapped: method.
	// If the user taps a song cell, the queue should be cleared and be replaced with the current
	// song list. Furthermore, the queue should jump to and start playing the just tapped song.
	
	if ([self songDataSourceIsSelected])
	{
		[self playSongInTableView:aTableView atIndexPath:indexPath];		
	
#if OHM_TARGET_4
		// We have to manually segue to the Ohm/Now Playing screen. Otherwise, the segue is already setup in the storyboard.
		
		[self segueToNowPlayingScreen];
#endif
	}
}

#pragma mark UITableViewDelegate Methods - Table Index Methods

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)aTableView
{
    if (![self songDataSourceIsSelected])
	{
		return [[self selectedTableViewDataSource] sectionIndexTitlesForTableView:aTableView];
	}
	
	return nil;
}

- (NSString *) tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    if (![self songDataSourceIsSelected])
	{
		return [[self selectedTableViewDataSource] tableView:aTableView titleForHeaderInSection:section];
	}
	
	return nil;
}

- (NSInteger) tableView:(UITableView *)aTableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (![self songDataSourceIsSelected])
	{
		return [[self selectedTableViewDataSource] tableView:aTableView sectionForSectionIndexTitle:title atIndex:index];
	}
	
	return 0;
}


#pragma mark Actions

- (IBAction) addSongButtonTapped:(UIView*)sender
{
	if ([self songDataSourceIsSelected])
	{
		[self queueSongInTableView:self.tableView atIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
	}
}

- (IBAction) shuffleAll
{
	NSParameterAssert([self songDataSourceIsSelected]);
	
	if ([self songDataSourceIsSelected])
	{
		// Shuffle all songs.
				
		[[self musicPlayer] playSongCollection:[self musicLibrary]];
		
		[[self musicPlayer] shuffle];
		
		//			[tableView reloadData]; // Reload the table view cells so the currently playing song is rendered correctly...
		
		[self segueToNowPlayingScreen];
	}

}

- (IBAction) segueToNowPlayingScreen:(id)sender
{
	[self segueToNowPlayingScreen];
}

- (IBAction)back:(id)sender
{
	[[self navigationController] popViewControllerAnimated:YES];
}

@end
