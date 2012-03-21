//
//  AlbumsTableViewDataSource.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "AlbumsTableViewDataSource.h"

#import "MusicLibrary.h"

static NSString* const CELL_REUSE_ID = @"AlbumsCell";

@implementation AlbumsTableViewDataSource

#pragma mark - Protected Methods

- (UITableViewCell*) tableViewCell
{
	return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_REUSE_ID];
}

- (NSArray*) allAlbums
{
	if (!albums)
	{
		albums = [musicLibrary() allAlbums];
	}
	
	return albums;
}

- (void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
	const NSInteger row = [indexPath row];
	
	if (row >= 0)
	{
		Album* album = [[self allAlbums] objectAtIndex:(NSUInteger)row];
		
		cell.textLabel.text = album.title;
		cell.detailTextLabel.text = album.artistName;
	}
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[[self allAlbums] count];
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
