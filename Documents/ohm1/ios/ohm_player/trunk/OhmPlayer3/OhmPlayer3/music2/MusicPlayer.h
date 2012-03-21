//
//  MusicPlayer.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MediaPlayer/MediaPlayer.h> // For notifications.

@class Song;
@class Album;

@protocol SongCollection;

// This protocol abstracts a music player.

#pragma mark MusicPlayer Protocol

@protocol MusicPlayer <NSObject>

@property (nonatomic, readonly) BOOL isPlaying; // Returns YES if music is audible.

@property (nonatomic, readonly) BOOL isStopped; // Returns YES if the music queue is empty.

// These return nil if the queue is empty.

@property (nonatomic, assign, readonly) NSUInteger indexOfNowPlayingSong;
@property (nonatomic, assign, readonly) NSUInteger countOfSongsInQueue;
@property (nonatomic, assign) NSTimeInterval currentPlaybackTime;
@property (nonatomic, strong, readonly) Song* nowPlayingSong;

- (void) playSong:(Song*)song inCollection:(NSObject<SongCollection>*)songCollection;

- (void) playSongCollection:(NSObject<SongCollection>*)songCollection;

- (BOOL) isPlayingSong:(Song*)aSong;

- (void) play;

- (void) pause;

- (void) stop;

- (void) skipToNextItem;

- (void) skipToPreviousItem;

- (void) shuffle;

@end

#pragma mark Music Player Functions

// This function returns a music player implementation appropriate for use in the iOS Simulator
// or on an iOS device depending on the compilation target.

typedef NSObject<MusicPlayer> MusicPlayer;

MusicPlayer* musicPlayer(void);
