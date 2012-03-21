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
	MutablePlaylist* ohmQueue;
	
	NSArray* previousCollectionSongs;
	
	NSMutableArray* activeSongQueue; // a copy of the current song collections queue that can be shuffled.
	
	NSObject<SongCollection>* currentSongCollection;

	NSInteger nowPlayingIndex;
	
	BOOL paused;
	
	dispatch_source_t playbackTimer;
	
}

@property (nonatomic, assign) NSTimeInterval currentPlaybackTime;

@property (nonatomic, readonly) BOOL isStopped;

+ (MusicPlayer*) sharedInstance;

@end
