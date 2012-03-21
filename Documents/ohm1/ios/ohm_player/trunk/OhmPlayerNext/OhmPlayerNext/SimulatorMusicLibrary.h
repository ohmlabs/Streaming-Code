/*
 
 SimulatorMusicLibrary.h
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import <Foundation/Foundation.h>

/*
 
 This class implements a music library implementation that can be used in the iOS Simulator.
 
 */

#import "MusicLibrary.h"

@interface SimulatorMusicLibrary : NSObject<MusicLibrary> {
    
	NSMutableDictionary*	artistToAlbums;
	NSMutableDictionary*	artistAndAlbumToSimulatorSong;
	NSMutableDictionary*	imageCache;
}

+ (MusicLibrary*) sharedInstance;

@end
