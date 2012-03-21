//
//  DeviceAlbum.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "DeviceAlbum.h"

#import "DeviceSong.h"

@implementation DeviceAlbum

#pragma mark Properties

@synthesize mediaItemCollection;

#pragma mark Album Properties - Overridden

- (NSArray*) songs
{
	NSMutableArray* songs = (NSMutableArray*)[super songs];
	
	if (![songs count])
	{
		for (MPMediaItem* item in [mediaItemCollection items])
		{
			DeviceSong* song = [[DeviceSong alloc] initWithMediaItem:item];
			
			if (song) [songs addObject:song];
		}
		
	}
	
	return songs;
}

#pragma mark SongCollection Methods

- (id) songCollection
{
	return [[MPMediaItemCollection alloc] initWithItems:mediaItemCollection.items];
}

#pragma mark Object Life Cycle

- (id) initWithMediaItemCollection:(id)aMediaItemCollection
{
	NSParameterAssert(aMediaItemCollection);
	
	NSString* aTitle		= [[aMediaItemCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
	NSString* anArtistName	= [[aMediaItemCollection representativeItem] valueForProperty:MPMediaItemPropertyArtist];
	
	if ((self = [self initWithTitle:aTitle artistName:anArtistName]))
	{
		mediaItemCollection = aMediaItemCollection;
	}
	
	return self;
}

- (id) init
{
	return [self initWithMediaItemCollection:nil];
}

@end
