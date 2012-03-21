/*
 
 MusicQueue.h
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import <Foundation/Foundation.h>


/*
 
 This protocol abstracts a music queue implementation.
 
 */

#pragma mark MusicQueue

@protocol MusicLibrarySong;

@protocol MusicQueue 

// Returns YES if the song is already in the queue.
- (BOOL) containsSong:(id<MusicLibrarySong>)aSong;

// Returns true if the song was successfully added.
- (BOOL) addSong:(id<MusicLibrarySong>)song;

- (void) play;

- (void) pause;

- (void) stop;

- (void)skipToNextItem;

- (void)skipToPreviousItem;

- (void)skipToItemAtIndex:(const NSUInteger)i;

- (NSUInteger) countOfSongs;

- (id) objectInSongsAtIndex:(NSUInteger)i;

@property (readonly) BOOL isPlaying;

@end

typedef NSObject<MusicQueue> MusicQueue;


#pragma mark Music Queue Functions

// This function returns a music queue implementation appropriate for use in the iOS Simulator
// or on an iOS device depending on the compilation target.

MusicQueue* musicQueue(void);
