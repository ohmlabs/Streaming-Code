//
//  GalleryListViewController.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "GalleryListViewController.h"

#import "AlbumsTableViewDataSource.h"
#import "ArtistsTableViewDataSource.h"
#import "SongsTableViewDataSource.h"

#import "MusicLibrary.h"
#import "MusicPlayer.h"
#import "MutablePlaylist.h"

// IMPORTANT: These indexes must match those in the corresponding storyboard.

enum {ARTISTS_TAB_INDEX = 0, ALBUMS_TAB_INDEX = 1 , SONGS_TAB_INDEX = 2};

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

#pragma mark - Protected Methods

- (NSUInteger) selectedTabBarIndex
{
	return [[tabBar items] indexOfObject:[tabBar selectedItem]];
}

- (void) selectTabBarButtonAtIndex:(NSUInteger)i
{
	if (i < [[tabBar items] count])
	{	
		tabBar.selectedItem = [[tabBar items] objectAtIndex:i];
		self.title = tabBar.selectedItem.title;
	}
}

- (NSObject<UITableViewDataSource, UITableViewDelegate>*) selectedTableViewDataSource
{
	NSObject<UITableViewDataSource, UITableViewDelegate>* dataSource = nil;
	
	const NSUInteger i = [self selectedTabBarIndex];
	
	switch (i) {
		case ALBUMS_TAB_INDEX:
			dataSource = [self albumsTableViewDataSource];
			break;

		case ARTISTS_TAB_INDEX:
			dataSource = [self artistsTableViewDataSource];
			break;

		case SONGS_TAB_INDEX:
			dataSource = [self songsTableViewDataSource];
			break;

		default:
			dataSource = [self albumsTableViewDataSource];
			break;
	}
	
	return dataSource;
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

#pragma mark UIViewController Methods

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewWillAppear:(BOOL)animated
{
	// Before the view appears, make a default selection if there isn't one.
	
	[self selectTabBarButtonAtIndex:ALBUMS_TAB_INDEX];
	
	[tableView reloadData]; // Reload the table view cells so the currently playing song is rendered correctly...

	[super viewWillAppear:animated];
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

#pragma mark UITabBarDelegate Methods

- (void)tabBar:(UITabBar *)aTabBar didSelectItem:(UITabBarItem *)item
{
	self.title = item.title;

	[tableView reloadData];
}

#pragma mark - UITableViewDataSource Methods

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
	return [[self selectedTableViewDataSource] tableView:aTableView cellForRowAtIndexPath:indexPath];
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
	
	const NSInteger row = [indexPath row];
	
	if (row >= 0)
	{
		if ([self albumDataSourceIsSelected])
		{
			Album* album = [albumsTableViewDataSource.allAlbums objectAtIndex:(NSUInteger)row];
			
			NSLog(@"Selected album: %@", album);
			NSLog(@"Its songs: %@", album.songs);
			
			// Add things to the ohm queue, which we assume the player is playing.
			// Then - for the sake of the prototype until the player responds to its own internal music change events - 
			// ask the player to synch to its playlist. Because we're doing this outside of a change in the now playing
			// item, we *expect* to hear a sound gap that interrupts the currently playing song while the queue is
			// forcibly updated.
			
			MutablePlaylist* playlist = [musicPlayer() ohmQueue];

			if (row == 0)
			{				
				[playlist addSongsForAlbum:album];
				
				// Tapping the first row places the "on-the-go" ohmQueue onto the player. Note: it may be empty..
				
				[musicPlayer() playSongCollection:playlist];
			}
			else
			{
				[playlist addSongsForAlbum:album];
			}

			// We actually want to play a playlist explictly...? i.e. start from the start?
			// it's the same playlist, so if it changes, we should not hear the audio gap (?)
			
			//[musicPlayer() synchToPlaylist];
		}
		else if ([self artistDataSourceIsSelected])
		{
			Artist* artist = [artistsTableViewDataSource.allArtists objectAtIndex:(NSUInteger)row];
			
			NSLog(@"Selected artist: %@", artist);
			NSLog(@"Their albums: %@", artist.albums);
			NSLog(@"Their songs: %@", artist.songs);
			
			// In the prototype, just start playing the first song of the first album for an artist.

			if ([artist.songs count] && [artist.albums count])
			{
				Song* song = [[artist songs] objectAtIndex:0];
			
				[musicPlayer() playSong:song inCollection:[artist.albums objectAtIndex:0]];
			}
		}
		else if ([self songDataSourceIsSelected])
		{
			// get the player, the current song, and the song collection to play.
			
			Song* song = [songsTableViewDataSource.allSongs objectAtIndex:(NSUInteger)row];
			
			[musicPlayer() playSong:song inCollection:musicLibrary()];
			
//			[tableView reloadData]; // Reload the table view cells so the currently playing song is rendered correctly...

			[self performSegueWithIdentifier:@"GalleryToNowPlaying" sender:self];
		}
		
		
	}
	
}

@end
