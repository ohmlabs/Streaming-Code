//
//  DeviceMusicPlayer.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MediaPlayer/MediaPlayer.h>

#import "MusicPlayer.h"

// This class represents an on-device music player.

@interface DeviceMusicPlayer : NSObject<MusicPlayer>
{
@private
	
	// This represents iOS's real player controller.
	
	MPMusicPlayerController* player;
	
	// Note: a song collection may be mutable. To determine
	// if it has changed, this ivar stores the previous
	// items of a collection. Between songs, this player can
	// determine if the contents of the current [mutable] collection
	// differs from the previous one and can update the real
	// [device] player queue accordingly.
	
	NSArray* previousCollectionMediaItems;
		
	// Note: it's slow to set the device's Now Playing queue
	// so we should not reset it if it hasn't changed. This ivar
	// tracks the current song collection so we can detect
	// if it needs to be replaced or not.
	
	NSObject<SongCollection>* currentSongCollection;
}

// Returns a singleton instance of this player.

+ (MusicPlayer*) sharedInstance;

@end
