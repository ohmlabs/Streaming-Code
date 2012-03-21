//
//  SimulatorArtist.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "SimulatorArtist.h"

#import "SimulatorAlbum.h"
#import "SimulatorSong.h"

@implementation SimulatorArtist

- (void) addSimulatorAlbum:(SimulatorAlbum*)album
{
	NSParameterAssert(album);
	
	if (album) [(NSMutableArray*)self.albums addObject:album];

	NSMutableArray* songs_ = (NSMutableArray*)self.songs;
	
	for (SimulatorSong* song in album.songs)
	{
		[songs_ addObject:song];
	}
	
}

@end
