//
//  SimulatorAlbum.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "SimulatorAlbum.h"

#import "SimulatorSong.h"

@implementation SimulatorAlbum

- (void) addSimulatorSong:(SimulatorSong*)song
{
	NSParameterAssert(song);
	
	if (song) [(NSMutableArray*)self.songs addObject:song];
}

@end
