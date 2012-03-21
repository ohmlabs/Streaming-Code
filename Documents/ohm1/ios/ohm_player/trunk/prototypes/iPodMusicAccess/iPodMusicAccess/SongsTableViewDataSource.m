//
//  SongsTableViewDataSource.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "SongsTableViewDataSource.h"

#import "MusicLibrary.h"
#import "MusicPlayer.h"

static NSString* const CELL_REUSE_ID = @"SongsCell";

@implementation SongsTableViewDataSource

#pragma mark - Protected Methods

- (UITableViewCell*) tableViewCell
{
	return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_REUSE_ID];
}

- (NSArray*) allSongs
{
	if (!songs)
	{
		songs = [musicLibrary() allSongs];
	}
	
	return songs;
}

- (void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
	const NSInteger row = [indexPath row];
	
	if (row >= 0)
	{
		Song* song = [[self allSongs] objectAtIndex:(NSUInteger)row];
		
		if ([musicPlayer() isPlayingSong:song])
		{
			cell.textLabel.textColor = [UIColor brownColor];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else
		{
			cell.textLabel.textColor = [UIColor darkTextColor];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
		cell.textLabel.text = song.title;
		
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
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[[self allSongs] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_ID];
	
	if (!cell)
	{
		cell = [self tableViewCell];
	}
	
	// Configure the cell...
	
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}

@end
