//
//  SimulatorMusicPlayer.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MusicPlayer.h"

// This class represents a simulated music player.

@interface SimulatorMusicPlayer : NSObject<MusicPlayer>
{	
	NSArray* previousCollectionSongs;
	
	NSMutableArray* activeSongs; // a copy of the current song collections queue that can be shuffled.
	
	NSObject<SongCollection>* currentSongCollection;

	NSUInteger nowPlayingIndex;
	
	BOOL paused;
	
	NSTimer* playbackTimer;
	
}

@property (nonatomic, readonly) BOOL isStopped;

+ (MusicPlayer*) sharedInstance;

@end
