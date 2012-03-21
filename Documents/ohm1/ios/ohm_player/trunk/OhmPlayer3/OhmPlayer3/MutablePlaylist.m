//
//  MutablePlaylist.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "MutablePlaylist.h"

#import "Album.h"
#import "Song.h"

@interface Playlist (ProtectedMethods)

- (NSMutableSet*) songIDsInPlaylist;

@end


@implementation MutablePlaylist

- (void) addSong:(Song*)song
{
	NSParameterAssert(song);
	
	if (song)
	{
		[(NSMutableArray*)self.songs addObject:song];
		
		// Record the song's ID in a set so we can implement containsSong...
		
		NSNumber* identifier = song.identifier;
		
		if (identifier) [[super songIDsInPlaylist] addObject:identifier];
		
	}
}

- (void) addSongsForAlbum:(Album*)album
{
	NSParameterAssert([album songs]);
	
	if ([album songs])
	{
		for (Song* song in [album songs])
		{
			[self addSong:song];
		}
		
	}
	
}


#pragma mark Playlist Methods -- Overriden

- (BOOL) readonly
{	
	return NO;
}

@end
