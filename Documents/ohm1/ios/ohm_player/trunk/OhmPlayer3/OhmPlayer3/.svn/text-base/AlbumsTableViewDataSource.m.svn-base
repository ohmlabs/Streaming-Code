//
//  AlbumsTableViewDataSource.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "AlbumsTableViewDataSource.h"

#import "MusicLibrary.h"

static NSString* const CELL_REUSE_ID = @"AlbumsCell";

static NSString* const PLACEHOLDER_ALBUM_IMAGE_NAME = @"default_album_artwork";

@implementation AlbumsTableViewDataSource

#pragma mark - Protected Methods

- (NSString*) imageCacheKeyForArtistName:(NSString*)artist andAlbumName:(NSString*)album
{
	NSParameterAssert(artist);
	NSParameterAssert(album);
	
	if (!artist || !album) return nil;
	
	return [NSString stringWithFormat:@"%@+%@", artist, album];
}

- (void) postImageCacheDidChangeNotification
{
	[[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:MusicLibraryImageCacheDidChangeNotification object:nil] postingStyle:NSPostWhenIdle];
}

- (UIImage*) placeholderAlbumImage
{
	static UIImage* placeholderImage = nil;
	
	if (!placeholderImage)
	{
		placeholderImage = [[UIImage imageNamed:PLACEHOLDER_ALBUM_IMAGE_NAME] copy];
	}
	
	return placeholderImage;
}

- (UITableViewCell*) tableViewCell
{
	return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_REUSE_ID];
}

- (MusicLibrary*) musicLibrary
{
	return musicLibrary();
}

- (NSMutableDictionary*) imageCache
{
	if (!imageCache)
	{
		imageCache = [[NSMutableDictionary alloc] init];
	}
		
	return imageCache;
}

- (UIImage*) imageWithSize:(CGSize)aSize forAlbum:(Album*)album
{
	NSString* key = [self imageCacheKeyForArtistName:album.artistName andAlbumName:album.title];
	
	NSAssert2(key, @"Could not get image cache key for artist %@ and album %@", album.artistName, album.title);
	
	if (!key) return nil;
	
	NSMutableDictionary* imageCache_ = [self imageCache];
	
	UIImage* image = [imageCache_ valueForKey:key];
	
	if (!image)
	{	
		
#if 1
		// Note: on my 2009 iPhone 3GS loading images on the main thread has acceptable performance.
		// In fact, it looks better than loading placeholder images for every cache miss.
		
		// A future alternative might be to preload the entire cache in the background to minimize
		// cache misses and prevent the placeholder album art from being displayed, but for now
		// I think this is more than OK to ship.
		
		image = [album imageWithSize:aSize];
		
		[imageCache_ setValue:image forKey:key];
#else
		// If the image wasn't in the cache we should return a placholder image,
		// load the real image in the background, then post a notification when the
		// image cache has been updated so a tableview can reload its cells.
		
		image = [self placeholderAlbumImage];
		
		[imageCache_ setValue:image forKey:key];
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
			
			UIImage* backgroundLoadedImage = [album imageWithSize:aSize];

			if (backgroundLoadedImage)
			{
				// Update the image cache on the main thread.
				
				dispatch_async(dispatch_get_main_queue(), ^{
					
					[imageCache_ setValue:backgroundLoadedImage forKey:key];
					
					[self postImageCacheDidChangeNotification];
				});
				
			}
		});
#endif
		
	}
	
	return image;
}

- (void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
	const NSInteger row		= [indexPath row];
	const NSInteger section	= [indexPath section];
		   
	if ((row >= 0) && (section >= 0))
	{		
		Album* album = [[self musicLibrary] albumAtIndexPath:indexPath];
		
		UIImage* image = [self imageWithSize:CGSizeMake(cell.frame.size.height, cell.frame.size.height) forAlbum:album];
		
		if (!image)
		{
			image = [self placeholderAlbumImage];
		}
		
		cell.imageView.image = image;
		cell.imageView.opaque = YES;
		cell.textLabel.text = album.title;
		cell.detailTextLabel.text = album.artistName;
	}
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 	return [[self musicLibrary] numberOfSectionsForAlbums];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self musicLibrary] numberOfRowsForAlbumSection:section];
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
	return [[self musicLibrary] titleForHeaderInAlbumSection:section];
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}


@end
