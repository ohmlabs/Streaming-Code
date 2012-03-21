//
//  SimulatorMusicPlayer.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "SimulatorMusicPlayer.h"

#import <MediaPlayer/MediaPlayer.h> // For MPMusicPlayerController notifications.

#import "Song.h"
#import "SongCollection.h"
#import "MutablePlaylist.h"

static const NSTimeInterval SIMULATED_SONG_DURATION	= 2.0; // seconds

@interface SimulatorMusicPlayer (ForwardDeclarations)

- (BOOL) hasNowPlayingSong;
- (BOOL) isPaused;
- (void) setNowPlayingIndex:(NSInteger)i;
- (void) synchToPlaylist;

@end

@implementation SimulatorMusicPlayer

#pragma mark Properties - MusicPlayer

@synthesize currentArtistName;
@synthesize currentAlbumTitle;
@synthesize currentSongTitle;
@synthesize currentPlaybackTime;

- (MutablePlaylist*) ohmQueue
{
	if (!ohmQueue)
	{
		ohmQueue = [[MutablePlaylist alloc] initWithName:NSLocalizedString(@"Queue", @"Queue")];
	}
	
	return ohmQueue;
}

- (BOOL) isPlaying
{
	return [self hasNowPlayingSong] && ![self isPaused];
}

- (BOOL) isStopped
{
	return ![self hasNowPlayingSong];
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
	return activeSongQueue;
}

- (BOOL) hasNowPlayingSong
{
	// Returnes YES, even if the player is paused.
	
	return (nowPlayingIndex >= 0);
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

	activeSongQueue = [previousCollectionSongs mutableCopy];
}

- (void) setQueueWithItemCollection:(NSObject<SongCollection>*)collection
{
	if (currentSongCollection != collection)
	{	
		[self internal_setQueueWithItemCollection:collection];
	}
	
}

- (Song*) nowPlayingSong
{
	if ([self hasNowPlayingSong])
	{
		return (nowPlayingIndex >= 0) ? [[self songs] objectAtIndex:(NSUInteger)nowPlayingIndex] : nil;
	}
	
	return nil;
}

- (void) setNowPlayingSong:(Song*)song
{	
	const NSUInteger i = [[self songs] indexOfObject:song];
	
	if (i != NSNotFound)
	{
		[self setNowPlayingIndex:(NSInteger)i];
	}
	
}

- (void) setNowPlayingIndex:(NSInteger)i
{	
	if (nowPlayingIndex == i)
	{
		[self play]; // If the "music" was paused, start it playing at the current index.
		return;
	}
	
	if ((i < 0) || (i >= (NSInteger)[[self songs] count]))
	{	
		// If this player is already stopped, don't notify of a playback state change.
		
		if (-1 != nowPlayingIndex)
		{
			// Stop.

			paused						= YES; 
			nowPlayingIndex				= -1;
			self.currentPlaybackTime	= 0.0F;
			previousCollectionSongs		= nil;
			currentSongCollection		= nil;
			
			currentAlbumTitle			= nil;
			currentArtistName			= nil;
			currentSongTitle			= nil;
						
			[self notifyPlayingStopped];
			
			[self notifyNowPlayingHasChanged];
		}
			
	}
	else
	{
		nowPlayingIndex					= i;
		self.currentPlaybackTime		= SIMULATED_SONG_DURATION;
		
		[self synchToPlaylist];
	
		Song* currentSong				= [self nowPlayingSong];
		
		currentAlbumTitle				= currentSong.albumName;
		currentArtistName				= currentSong.artistName;
		currentSongTitle				= currentSong.title;
		
		NSLog(@"Now playing song: %@" , currentSong);
		
		[self notifyNowPlayingHasChanged];

		[self play]; // If the "music" was paused, start it playing at the new index.
		
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
		
		[self play];
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
	// If it goes to zero, call skipToNextSong...
	
	if (!paused && ![self isStopped])
	{
		self.currentPlaybackTime -= 1.0F;
		
		if (self.currentPlaybackTime <= 0)
		{
			[self skipToNextItem];
		}
	}
							
}

- (void) setUpTimer
{	
	// Set up a timer that fires once per second and calls this object's clock tick method
	// to simulate elapsed playback time.
	
	playbackTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
	dispatch_time_t startTime = dispatch_walltime(DISPATCH_TIME_NOW, 0);
	dispatch_source_set_timer(playbackTimer, startTime, NSEC_PER_SEC, 5000ull);
	
	dispatch_source_set_event_handler(playbackTimer, ^{	
		
		// Call clock tick repeatedly on the main queue.
		
		[self simulatedClockTick];
		
	});
	
	dispatch_resume(playbackTimer);
}

#pragma mark Public Methods

- (BOOL) isPlayingSong:(Song*)aSong
{
	const NSUInteger i = [[self songs] indexOfObject:aSong];
	
	return (i == NSNotFound) ? NO : (nowPlayingIndex == (NSInteger)i);
}

- (void) playSong:(Song*)song inCollection:(NSObject<SongCollection>*)collection
{	
	NSParameterAssert(collection);
	NSParameterAssert(song);
	
	[self setQueueWithItemCollection:collection];
	
	[self setNowPlayingSong:song];
	
	[self play];
}

- (void) playSongCollection:(NSObject<SongCollection>*)collection
{
	[self setQueueWithItemCollection:collection];
	
	[self play];
}

- (void) play
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
		nowPlayingIndex = -1;
		
		[self setUpTimer];
    }
	
    return self;
}

- (void)dealloc
{
    dispatch_source_cancel(playbackTimer); playbackTimer = 0;
}

+ (MusicPlayer*) sharedInstance
{
	static MusicPlayer* sharedInstance = nil;
	
	if (!sharedInstance)
	{
		sharedInstance = (MusicPlayer*)[[SimulatorMusicPlayer alloc] init];
	}
	
	return sharedInstance;
}

@end
