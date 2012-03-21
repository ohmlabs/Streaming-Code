//
//  MutablePlaylist.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "MutablePlaylist.h"

#import "Album.h"

@implementation MutablePlaylist

- (void) addSong:(Song*)song
{
	NSParameterAssert(song);
	
	if (song) [(NSMutableArray*)self.songs addObject:song];
}

- (void) addSongsForAlbum:(Album*)album
{
	NSParameterAssert([album songs]);

	if ([album songs])
	{
		[(NSMutableArray*)self.songs addObjectsFromArray:[album songs]];
	}

}

@end
