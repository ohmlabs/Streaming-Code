//
//  DevicePlaylist.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "DevicePlaylist.h"

#import "DeviceSong.h"

@interface Playlist (ProtectedMethods)

- (NSMutableSet*) songIDsInPlaylist;

@end

@implementation DevicePlaylist

#pragma mark Properties

@synthesize mediaPlaylist;

#pragma mark Protected Methods

- (void) addSong:(Song*)song
{
	NSParameterAssert(song);
	
	if (song)
	{
		[(NSMutableArray*)super.songs addObject:song];
		
		// Record the song's ID in a set so containsSong can be implemented...
		
		NSNumber* identifier = song.identifier;
		
		if (identifier) [[super songIDsInPlaylist] addObject:identifier];
		
	}
}

#pragma mark Playlist Methods - Overriden

- (NSArray*) songs
{
	if (![super.songs count])
	{
		// If the songs list is empty, try to compute it. Playlist should never be empty...
		
        // PERFORMANCE: the items method below is slow, but it's no slower than Apple's own Music app.
        // For example, a playlist of 2500 songs takes about 40 seconds to load on an iPhone 3GS
        // for both Ohm Player and Apple's Music.app.
        
		for (MPMediaItem* item in [mediaPlaylist items])
		{
			Song* song = [[DeviceSong alloc] initWithMediaItem:item];
			
			if (song) [self addSong:song];
		}
		
	}
	
	return super.songs;
}

- (NSUInteger) count
{
    return [mediaPlaylist count];
}

#pragma mark SongCollection Methods

- (id) songCollection
{
	return [[MPMediaItemCollection alloc] initWithItems:mediaPlaylist.items];
}

#pragma mark Object Life Cycle

- (id) initWithMediaPlaylist:(id)aMediaPlaylist
{
	NSParameterAssert(aMediaPlaylist);
	
	NSString* aName	= [aMediaPlaylist valueForProperty:MPMediaPlaylistPropertyName];
	
	if ((self = [self initWithName:aName]))
	{
		mediaPlaylist = aMediaPlaylist;
	}
	
	return self;
}

- (id) init
{
	return [self initWithMediaPlaylist:nil];
}

@end
