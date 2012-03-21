//
//  MusicPlayer.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Song;
@class Album;
@class MutablePlaylist;

@protocol SongCollection;

// This protocol abstracts a music player.

#pragma mark MusicPlayer Protocol

@protocol MusicPlayer <NSObject>

@property (atomic, strong, readonly) MutablePlaylist* ohmQueue;

@property (nonatomic, readonly) BOOL isPlaying; // Music is not paused.

@property (nonatomic, readonly) BOOL isStopped;

// These return nil if the queue is empty.

@property (nonatomic, strong, readonly) NSString* currentArtistName;
@property (nonatomic, strong, readonly) NSString* currentAlbumTitle;
@property (nonatomic, strong, readonly) NSString* currentSongTitle;

- (void) playSong:(Song*)song inCollection:(NSObject<SongCollection>*)songCollection;

- (void) playSongCollection:(NSObject<SongCollection>*)songCollection;

- (BOOL) isPlayingSong:(Song*)aSong;

- (void) play;

- (void) pause;

- (void) stop;

- (void) skipToNextItem;

- (void) skipToPreviousItem;

@end

#pragma mark Music Player Functions

// This function returns a music player implementation appropriate for use in the iOS Simulator
// or on an iOS device depending on the compilation target.

typedef NSObject<MusicPlayer> MusicPlayer;

MusicPlayer* musicPlayer(void);
