//
//  DeviceMutablePlaylist.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "DeviceMutablePlaylist.h"

#import "DeviceSong.h"
#import "DeviceAlbum.h"

@implementation DeviceMutablePlaylist

#pragma mark Protected Methods

- (NSArray*) mediaItems
{
	if (!mediaItems)
	{
		mediaItems = [[NSMutableArray alloc] init];
	}
	
	return mediaItems;
}

// Returns YES if the media items were successfully updated, otherwise NO.

- (BOOL) addSongsMediaItems:(NSArray*)newMediaItems
{	
	NSParameterAssert(newMediaItems);
		
	if (newMediaItems)
	{
		// Update the device specific collection.

		NSArray* targetCollectionItems = [[self mediaItems] arrayByAddingObjectsFromArray:newMediaItems];
		
		if ([targetCollectionItems count])
		{
			MPMediaItemCollection* newItemCollection = [[MPMediaItemCollection alloc] initWithItems:targetCollectionItems];
			
			if (newItemCollection)
			{
				mediaItems = [newItemCollection items];
				
				return YES;
			}
		}
	}
	
	return NO;

}

- (BOOL) addSongMediaItem:(MPMediaItem*)item
{	
	return (item) ? [self addSongsMediaItems:[NSArray arrayWithObject:item]] : NO;
}

- (BOOL) addSongMediaItemCollection:(MPMediaItemCollection*)collection
{	
	return (collection) ? [self addSongsMediaItems:[collection items]] : NO;
}

#pragma mark MutablePlaylist Methods

- (void) addSong:(Song*)song
{
	MPMediaItem* mediaItem = ((DeviceSong*)song).mediaItem;
	
	NSParameterAssert(mediaItem);
	
	if ([self addSongMediaItem:mediaItem])
	{
		// On success, indirectly update the inherited Songs property so that this
		// playlist's songs can be displayed in a tableview.
		
		[super addSong:song];
	}
}

- (void) addSongsForAlbum:(Album*)album
{
	MPMediaItemCollection* collection = ((DeviceAlbum*)album).mediaItemCollection;
	
	NSParameterAssert(collection);
	
	if ([self addSongMediaItemCollection:collection])
	{
		// On success, indirectly update the inherited Songs property so that this
		// playlist's songs can be displayed in a tableview.
		
		[super addSongsForAlbum:album];
	}
}

#pragma mark SongCollection Methods

- (id) songCollection
{
	return ([mediaItems count]) ? [[MPMediaItemCollection alloc] initWithItems:mediaItems] : nil;
}

@end
