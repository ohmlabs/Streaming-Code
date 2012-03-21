//
//  SimulatorMusicPlayer.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "SimulatorMusicPlayer.h"

#import <MediaPlayer/MediaPlayer.h> // For MPMusicPlayerController notifications.

#import "Song.h"
#import "SongCollection.h"

@interface SimulatorMusicPlayer (ForwardDeclarations)

- (BOOL) hasQueuedSongs;
- (BOOL) isPaused;
- (void) setNowPlayingIndex:(NSInteger)i;
- (void) synchToPlaylist;
- (void) unpause;
- (NSArray*) songs;

@end

@implementation SimulatorMusicPlayer

#pragma mark Properties - MusicPlayer

@synthesize currentPlaybackTime;

- (BOOL) isPlaying
{
	return [self hasQueuedSongs] && ![self isPaused];
}

- (BOOL) isStopped
{
	return ![self hasQueuedSongs];
}

- (NSUInteger) countOfSongsInQueue
{
	return [[self songs] count];
}

- (NSUInteger) indexOfNowPlayingSong
{
	return nowPlayingIndex;
}

- (Song*) nowPlayingSong
{
	if ([self hasQueuedSongs])
	{
		return [[self songs] objectAtIndex:nowPlayingIndex];
	}
	
	return nil;
}

- (void) setNowPlayingSong:(Song*)song
{	
	const NSUInteger i = [[self songs] indexOfObject:song];
	
	if (i != NSNotFound)
	{
		[self setNowPlayingIndex:i];
	}
	
}

#pragma mark Protected Methods - Notifications

- (void) notifyNowPlayingHasChanged
{	
	NSNotification* note = [NSNotification notificationWithName:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
	
	[[NSNotificationQueue defaultQueue] enqueueNotification:note postingStyle:NSPostASAP];
}

- (void) notifyPlaybackStateChanged
{
	NSNotification* note = [NSNotification notificationWithName:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self];
	
	[[NSNotificationQueue defaultQueue] enqueueNotification:note postingStyle:NSPostASAP];
}

- (void) notifyPlayingStarted
{
	[self notifyPlaybackStateChanged];
}

- (void) notifyPlayingStopped
{
	[self notifyPlaybackStateChanged];
}

- (void) notifyPlayingPaused
{
	[self notifyPlaybackStateChanged];
}

#pragma mark Protected Methods

- (NSArray*) songs
{
	return activeSongs;
}

- (BOOL) hasQueuedSongs
{	
	return ([self countOfSongsInQueue] != 0);
}

- (BOOL) isPaused
{
	return paused;
}

- (NSArray*) mediaSongsFromSongCollection:(NSObject<SongCollection>*)collection
{
	return (NSArray*)[collection songCollection];
}

- (void) internal_setQueueWithItemCollection:(NSObject<SongCollection>*)collection
{
	currentSongCollection = collection;
	
	// The player remembers collection items so it can later detect
	// if the collection has been modified.
	
	previousCollectionSongs = [[self mediaSongsFromSongCollection:collection] copy];

	activeSongs = [previousCollectionSongs mutableCopy];
}

- (void) setQueueWithItemCollection:(NSObject<SongCollection>*)collection
{
	if (currentSongCollection != collection)
	{	
		[self internal_setQueueWithItemCollection:collection];
	}
	
}

- (void) setNowPlayingIndex:(NSUInteger)i
{	
	if (nowPlayingIndex == i)
	{
		[self unpause]; // If the "music" was paused, start it playing at the current index.
		return;
	}
	
	if ((i == NSNotFound) || (i >= [self countOfSongsInQueue]))
	{	
		// If this player is already stopped, don't notify of a playback state change.
		
		if (NSNotFound != nowPlayingIndex)
		{
			// Stop.

			nowPlayingIndex				= NSNotFound;
			self.currentPlaybackTime	= 0.0F;
			previousCollectionSongs		= nil;
			currentSongCollection		= nil;
			activeSongs					= nil;

			[self notifyPlayingStopped];
			
			[self notifyNowPlayingHasChanged];
		}
			
	}
	else
	{
		nowPlayingIndex					= i;

		Song* currentSong				= [self nowPlayingSong];
		self.currentPlaybackTime		= 0;
		
		[self synchToPlaylist];

		NSLog(@"Now playing song: %@" , currentSong);
		
		[self notifyNowPlayingHasChanged];

		[self unpause]; // If the "music" was paused, start it playing at the new index.
		
	}

}

- (void) updateMusicQueue
{	
	if (currentSongCollection)
	{
		Song* nowPlayingSong = [self nowPlayingSong];
		
		const NSTimeInterval currentPlaybackTime_ = [self currentPlaybackTime];
		
		[self internal_setQueueWithItemCollection:currentSongCollection];
		
		[self setNowPlayingSong:nowPlayingSong];
		
		[self setCurrentPlaybackTime:currentPlaybackTime_];
		
	}
}

- (void) synchToPlaylist
{	
	NSArray* currentMediaItems = [self mediaSongsFromSongCollection:currentSongCollection];
	
	if (![previousCollectionSongs isEqualToArray:currentMediaItems])
	{
		// The current media items have changed since the queue/collection was last set. Update it.
		
		[self updateMusicQueue];
	}
	
}

#pragma mark Protected Methods - Timer Callback

- (void) simulatedClockTick
{	
	// This method is called one a second.
	
	// If the player is not paused, reduce the playback time.
	// If it exceeds the playback duration, call skipToNextSong...
	
	if (!paused && ![self isStopped])
	{
		self.currentPlaybackTime += 1.0F;
		
		if (self.currentPlaybackTime >= [[self nowPlayingSong].playbackDuration doubleValue])
		{
			[self skipToNextItem];
		}
	}
							
}

- (void) setUpTimer
{	
	// Set up a timer that fires once per second and calls this object's clock tick method
	// to simulate elapsed playback time.
	
	if (!playbackTimer)
	{
		playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0F /*secs*/ target:self selector:@selector(simulatedClockTick) userInfo:nil repeats:YES];
	}
	
}

#pragma mark Public Methods

- (BOOL) isPlayingSong:(Song*)aSong
{
	const NSUInteger i = [[self songs] indexOfObject:aSong];
	
	return (i == NSNotFound) ? NO : (nowPlayingIndex == i);
}

- (void) playSong:(Song*)song inCollection:(NSObject<SongCollection>*)collection
{	
	NSParameterAssert(collection);
	NSParameterAssert(song);
	
	[self setQueueWithItemCollection:collection];
	
	[self setNowPlayingSong:song];
	
}

- (void) playSongCollection:(NSObject<SongCollection>*)collection
{
	[self setQueueWithItemCollection:collection];
	
	[self setNowPlayingIndex:0];
}

- (void) play
{
	// Start playing at the head of the list or resume where we left off...
	
	[self setNowPlayingIndex:nowPlayingIndex];
}

- (void) unpause
{
	if (paused)
	{
		paused = NO;
		
		[self notifyPlayingStarted];
	}
	
}

- (void) pause
{
	if (!paused)
	{
		paused = YES;
		
		[self notifyPlayingPaused];
	}
	
}

- (void) stop
{
	[self setNowPlayingIndex:-1];
}

- (void)skipToNextItem
{
	[self setNowPlayingIndex:nowPlayingIndex + 1];		
}

- (void)skipToPreviousItem
{
	[self setNowPlayingIndex:nowPlayingIndex - 1];
}

- (void) shuffle
{
	//  http://en.wikipedia.org/wiki/Knuth_shuffle
	//
	//	To shuffle an array a of n elements (indexes 0..n-1):
	//	for i from n − 1 downto 1 do
	//		j ← random integer with 0 ≤ j ≤ i
	//		exchange a[j] and a[i]
	
	NSMutableArray* array = (NSMutableArray*)[self songs];
	
	for (NSUInteger i = ([array count] - 1); i > 0 ; i--)
	{
		const NSUInteger j = ((NSUInteger)random() % i);
		
		[array exchangeObjectAtIndex:j withObjectAtIndex:i];
	}
	
}

#pragma mark Object Life Cycle

- (id)init
{
    self = [super init];
    if (self)
	{
		nowPlayingIndex = -1; paused = YES;
		
		[self setUpTimer];
    }
	
    return self;
}

- (void)dealloc
{
	[playbackTimer invalidate]; playbackTimer = 0;
}

+ (MusicPlayer*) sharedInstance
{
	static id sharedInstance = nil;
	
    if (sharedInstance) return sharedInstance;
    
	@synchronized (self)
    {
        if (!sharedInstance)
        {
            sharedInstance = (MusicPlayer*)[[SimulatorMusicPlayer alloc] init];
        }
    }
    
	return sharedInstance;
}

@end
