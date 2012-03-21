//
//  DeviceMusicLibrary.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "DeviceMusicLibrary.h"

#import "DeviceArtist.h"
#import "DeviceAlbum.h"
#import "DeviceSong.h"

@implementation DeviceMusicLibrary

#pragma mark MusicLibrary Methods

- (NSArray*) allArtists
{	
	if (!allArtists)
	{
		allArtists = [[NSMutableArray alloc] init];
		
		MPMediaQuery *query = [MPMediaQuery artistsQuery];
		
		for (MPMediaItem* item in [query collections])
		{			
			id artist = [[DeviceArtist alloc] initWithMediaItemCollection:item];
			
			if (artist)
			{
				[allArtists addObject:artist];
			}
		}
		
	}
	
	return allArtists;
}

- (NSArray*) allAlbums
{	
	if (!allAlbums)
	{
		allAlbums = [[NSMutableArray alloc] init];
		
		MPMediaQuery *query = [MPMediaQuery albumsQuery];
		
		for (MPMediaItem* item in [query collections])
		{			
			id album = [[DeviceAlbum alloc] initWithMediaItemCollection:item];
			
			if (album)
			{
				[allAlbums addObject:album];
			}
		}
		
	}
	
	return allAlbums;
}

- (NSArray*) allSongs
{	
	if (!allSongs)
	{
		allSongs = [[NSMutableArray alloc] init];
				
		for (MPMediaItem* item in [[MPMediaQuery songsQuery] items])
		{			
			id album = [[DeviceSong alloc] initWithMediaItem:item];
			
			if (album)
			{
				[allSongs addObject:album];
			}
		}
		
	}
	
	return allSongs;
}

#pragma mark SongCollection Methods

- (id) songCollection
{
	return [[MPMediaItemCollection alloc] initWithItems:[MPMediaQuery songsQuery].items];
}

#pragma mark Object Life Cycle

+ (MusicLibrary*) sharedInstance
{
	static MusicLibrary* sharedInstance = nil;
	
	if (!sharedInstance)
	{
		sharedInstance = [[DeviceMusicLibrary alloc] init];
	}
	
	return sharedInstance;
}

@end
