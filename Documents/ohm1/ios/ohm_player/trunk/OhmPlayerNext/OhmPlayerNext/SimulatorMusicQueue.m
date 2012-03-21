/*
 
 SimulatorMusicQueue.m
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import "SimulatorMusicQueue.h"

#import "MusicLibrarySong.h"

static NSTimeInterval SIMULATED_SONG_DURATION	= 2.0; // seconds

@interface SimulatorMusicQueue ()

- (void)handleSongEnded:(NSTimer*)theTimer;

- (void)stop;

@end

@implementation SimulatorMusicQueue

#pragma mark Properties

- (BOOL) isPlaying
{
	return [songTimer isValid];
}

- (NSUInteger) countOfSongs
{
	return [songs count];
}

- (id) objectInSongsAtIndex:(NSUInteger)i
{
	return [songs objectAtIndex:i];
}

#pragma mark Protected Methods

- (void) resetTimeRemaining
{
	secondsRemaining = 0.0F;
}

- (void) selectFirstSongInQueue
{
	indexOfCurrentSong = 0;
}

- (BOOL) queueIsFinishedPlaying
{
	return (indexOfCurrentSong >= [songs count]);
}

- (void) startTimer
{
	NSAssert1(!songTimer, @"Times is already running!", nil);
	
	if (!songTimer)
	{
		songTimer = [NSTimer scheduledTimerWithTimeInterval:(SIMULATED_SONG_DURATION - secondsRemaining) target:self selector:@selector(handleSongEnded:) userInfo:nil repeats:NO];
		[songTimer retain];
	}
}

- (void) removeTimer
{
	[songTimer invalidate];
	[songTimer release];
	songTimer = nil;
}

- (void) startCountdownToEndOfSong
{
	NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
	
	NSLog(@"Now playing %@", [songs objectAtIndex:indexOfCurrentSong]);
	
	[self startTimer];
}

- (void) stopCountdownToEndOfSong
{
	NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
	
	// $$$$$ record time remaining so we can resume later...

	[self removeTimer];
}

- (void)handleSongEnded:(NSTimer*)theTimer
{
	NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
		
	[self removeTimer];
		
	[self skipToNextItem];

	if (![self queueIsFinishedPlaying])
	{
		[self play]; // Continue playing if the queue isn't finished.
	}
	else
	{
		// The queue is done.
		// Restart from the begining but wait for the user to hit play before playing again...
		[self stop];
	}
	
}

#pragma mark MusicQueue Methods

- (BOOL) containsSong:(id<MusicLibrarySong>)aSong
{
	NSParameterAssert([aSong identifier]);
	
	if (![aSong identifier]) return NO;
	
	NSString* songID = [aSong identifier];
	
	for (MusicLibrarySong* song in songs)
	{
		if ([[song identifier] isEqualToString:songID])
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL) addSong:(id<MusicLibrarySong>)song
{
	NSParameterAssert(songs);
	NSParameterAssert(song);
	
	if (!song || !songs) return NO;
	
	[songs addObject:song];
	
	[self play]; // If already playing, continue playing, otherwise start the newly added song...
		
	NSLog(@"QUEUE: %@", songs);
	
	return YES;
}

- (void) play
{	
	if (self.isPlaying)
	{
		// Continue playing the current song.
		return;
	}
	else if (![self queueIsFinishedPlaying])
	{
		// Start playing the current song.
		[self startCountdownToEndOfSong];
	}
	
}

- (void) pause
{
	if (self.isPlaying)
	{
		// Pause playing the current song.
		[self stopCountdownToEndOfSong];
	}
		
}

- (void) stop
{
	NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
	
	[self removeTimer];
	
	[self selectFirstSongInQueue];
	
	[self resetTimeRemaining];
}

- (void)skipToNextItem
{		
	NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
	
	indexOfCurrentSong++;

	[self resetTimeRemaining];	
}

- (void)skipToPreviousItem
{
	NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
	
	if (indexOfCurrentSong > 0) indexOfCurrentSong--;
	
	[self resetTimeRemaining];
}

- (void)skipToItemAtIndex:(const NSUInteger)row
{
	[self stop];
	
	for (NSUInteger i = 0; i < row; i++)
	{
		[self skipToNextItem];
		
		if ([self queueIsFinishedPlaying])
		{
			break;
		}
	}
	
	[self play];
}

#pragma mark Object Life Cycle

+ (MusicQueue*) sharedInstance
{
	static MusicQueue* sharedInstance = nil;
	
	if (!sharedInstance)
	{
		sharedInstance = [[SimulatorMusicQueue alloc] init];
	}
	
	return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) 
	{
        songs						= [[NSMutableArray alloc] init];
		secondsRemaining			= 0.0;
    }
    return self;
}

- (void)dealloc
{
	[songs release];
	[songTimer release];
	
    [super dealloc];
}

@end
