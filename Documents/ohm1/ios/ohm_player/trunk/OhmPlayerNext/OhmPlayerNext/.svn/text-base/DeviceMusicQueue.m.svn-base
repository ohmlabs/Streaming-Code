/*
 
 DeviceMusicQueue.m
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import "DeviceMusicQueue.h"

#import <MediaPlayer/MediaPlayer.h>

#import "MusicLibrarySong.h"
#import "DeviceSong.h"

@implementation DeviceMusicQueue

#pragma mark Properties

- (BOOL) isPlaying
{
	return ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying);
}

- (NSUInteger) countOfSongs
{
	return [currentQueue count];
}

- (id) objectInSongsAtIndex:(NSUInteger)i
{
	MPMediaItem* mediaItem = [[currentQueue items] objectAtIndex:i];
	return (mediaItem) ? [[[DeviceSong alloc] initWithMediaItem:mediaItem] autorelease] : nil;
}

#pragma mark Protected Methods

- (MPMusicPlayerController*) musicPlayer
{
	static MPMusicPlayerController* player = nil;
	
	if (!player)
	{
		player = [MPMusicPlayerController iPodMusicPlayer];
		
		[player beginGeneratingPlaybackNotifications];
	}
	
	return player;
}

- (void) addMediaItemsToMusicPlayerQueue:(NSArray*)mediaItems
{
	MPMusicPlayerController* player = [self musicPlayer];
	
	if ([mediaItems count])
	{
		if (!currentQueue)
		{
			// Create a new queue.
			
			currentQueue = [[MPMediaItemCollection alloc] initWithItems:mediaItems];
		}
		else
		{
			// Modify the existing queue.
			
			NSMutableArray* existingQueueSongs = [[currentQueue items] mutableCopy];
			
			[existingQueueSongs addObjectsFromArray:mediaItems];

			[currentQueue autorelease];
			
			currentQueue = [[MPMediaItemCollection alloc] initWithItems:existingQueueSongs];

			[existingQueueSongs release];
		}
	
		// Save the now-playing item and its current playback time.
		MPMediaItem *nowPlayingItem			= [self musicPlayer].nowPlayingItem;
		NSTimeInterval currentPlaybackTime	= [self musicPlayer].currentPlaybackTime;

		[player setQueueWithItemCollection:currentQueue];
	
		// Restore the now-playing item and its current playback time.
		[self musicPlayer].nowPlayingItem			= nowPlayingItem;
		[self musicPlayer].currentPlaybackTime		= currentPlaybackTime;

		[player play];

		// $$$$$ ISSUE: The code above, as well as the Apple sample code (AddMusic) both result
		// in a short pause in playing music when modifying the music queue. Note: the official
		// iPod app does not suffer this issue. It's possible Apple is being smart about this -
		// they probably don't update the queue until the currently playing song ends, is paused
		// or the user skips forward or backward...
		
	}
	
}

- (void) addPendingSong:(id<MusicLibrarySong>)aSong
{
	MPMediaItem* mediaItem = ((DeviceSong*)aSong).mediaItem;
	
	if (!mediaItem) return;
	
	[pendingMediaItems addObject:mediaItem];
}

- (void) addSongToMusicPlayerQueue:(id<MusicLibrarySong>)aSong
{	
	MPMediaItem* mediaItem = ((DeviceSong*)aSong).mediaItem;
	
	if (!mediaItem) return;
	
	NSArray* mediaItems = [NSArray arrayWithObject:mediaItem];
	
	[self addMediaItemsToMusicPlayerQueue:mediaItems];
	
}

#pragma mark MusicQueue Methods

- (BOOL) containsSong:(id<MusicLibrarySong>)aSong
{
	NSParameterAssert([aSong identifier]);
	
	if (![aSong identifier]) return NO;
	
	NSString* songID = [aSong identifier];

	if (songID)
	{
		return [songIDsInQueue containsObject:songID];
	}
	
	return NO;
}

- (BOOL) addSong:(id<MusicLibrarySong>)aSong
{
	NSParameterAssert([aSong identifier]);
	
	if (![aSong identifier]) return NO;
	
	NSString* songID = [aSong identifier];
	
	NSLog(@"Adding songID = %@", songID);
	
	[songIDsInQueue addObject:songID];
	
	if ([self isPlaying])
	{		
		// Simply pend the song and add it later when the song ends.
		NSLog(@"Pending song %@", aSong);
		
		[self addPendingSong:aSong];
	}
	else
	{
		// Add the song immediately and start it paying.
		NSLog(@"Playing song %@", aSong);

		[self addSongToMusicPlayerQueue:aSong];
	}
	
	return YES;
}

- (void) play
{
	[[self musicPlayer] play];
}

- (void) pause
{
	[[self musicPlayer] pause];
}

- (void) stop
{
	[[self musicPlayer] stop];
}

- (void)skipToNextItem
{
	[[self musicPlayer] skipToNextItem];
}

- (void)skipToPreviousItem
{
	[[self musicPlayer] skipToPreviousItem];
}

- (void)skipToItemAtIndex:(const NSUInteger)row
{	
	DeviceSong* song = [self objectInSongsAtIndex:row];
	
	if (song)
	{
		// Setting the nowPlayingItem to an item in the current
		// queue will begin playback at that item.
		
		[self musicPlayer].nowPlayingItem = song.mediaItem;
	}
	
}

#pragma mark Notification Handlers


- (void) handleSongChange:(NSNotification*)notification
{	
	NSLog(@"*** Pending media items %@", pendingMediaItems);
	
	[self addMediaItemsToMusicPlayerQueue:pendingMediaItems];
	
	[pendingMediaItems removeAllObjects];
}

#pragma mark Notifications

- (void) registerForNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleSongChange:)
												 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
											   object:nil];
}

- (void) unregisterForNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Object Life Cycle

+ (MusicQueue*) sharedInstance
{
	static MusicQueue* sharedInstance = nil;
	
	if (!sharedInstance)
	{
		sharedInstance = [[DeviceMusicQueue alloc] init];
	}
	
	return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) 
	{
        songIDsInQueue = [[NSMutableSet alloc] init];
		pendingMediaItems = [[NSMutableArray alloc] init];
    }

	[self registerForNotifications];

	return self;
}

- (void)dealloc
{
	[self unregisterForNotifications];

	[songIDsInQueue release];
	[currentQueue release];
	[pendingMediaItems release];
	
    [super dealloc];
}

@end
