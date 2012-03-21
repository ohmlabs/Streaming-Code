//
//  ArtistsTableViewDataSource.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "ArtistsTableViewDataSource.h"

#import "MusicLibrary.h"

static NSString* const CELL_REUSE_ID = @"ArtistsCell";

@implementation ArtistsTableViewDataSource

#pragma mark - Protected Methods

- (UITableViewCell*) tableViewCell
{
	return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_REUSE_ID];
}

- (NSArray*) allArtists
{
	if (!artists)
	{
		artists = [musicLibrary() allArtists];
	}
					
	return artists;
}

- (void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
	const NSInteger row = [indexPath row];
	
	if (row >= 0)
	{
		Artist* artist = [[self allArtists] objectAtIndex:(NSUInteger)row];
		
		cell.textLabel.text = artist.name;
	}
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[[self allArtists] count];
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
