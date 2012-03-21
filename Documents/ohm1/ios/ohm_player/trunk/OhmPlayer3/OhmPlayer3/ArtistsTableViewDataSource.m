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

- (MusicLibrary*) musicLibrary
{
	return musicLibrary();
}

- (void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{	
	Artist* artist = [[self musicLibrary] artistAtIndexPath:indexPath];
	
	cell.textLabel.text = artist.name;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 	return [[self musicLibrary] numberOfSectionsForArtists];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self musicLibrary] numberOfRowsForArtistSection:section];
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

#pragma mark UITableViewDataSource Methods - Table Index

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[self musicLibrary] titleForHeaderInArtistSection:section];
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

@end
