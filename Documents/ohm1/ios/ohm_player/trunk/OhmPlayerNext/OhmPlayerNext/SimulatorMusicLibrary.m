/*
 
 SimulatorMusicLibrary.m
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import "SimulatorMusicLibrary.h"

#import "SimulatorSong.h"

static NSString* const PLACEHOLDER_ALBUM_IMAGE_NAME = @"Album_artwork_filler";
static NSString* const SIMULATOR_ALBUM_IMAGE_NAME	= @"Album_artwork_filler";

@implementation SimulatorMusicLibrary

- (UIImage*) placeholderAlbumImage
{
	static UIImage* placeholderImage = nil;
	
	if (!placeholderImage)
	{
		placeholderImage = [[UIImage imageNamed:PLACEHOLDER_ALBUM_IMAGE_NAME] copy];
	}
	
	return placeholderImage;
}

- (UIImage*) simulatorAlbumImage
{
	static UIImage* simulatorAlbumImage = nil;
	
	if (!simulatorAlbumImage)
	{
		simulatorAlbumImage = [[UIImage imageNamed:SIMULATOR_ALBUM_IMAGE_NAME] copy];
	}
	
	return simulatorAlbumImage;
}

- (void) postImageCacheUpdatedNotification
{
	[[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:MusicLibraryImageCacheUpdatedNotification object:nil] postingStyle:NSPostWhenIdle];
}

- (NSString*) keyForArtist:(NSString*)artist andAlbum:(NSString*)album
{
	NSParameterAssert(artist);
	NSParameterAssert(album);
	
	if (!artist || !album) return nil;
	
	return [NSString stringWithFormat:@"%@+%@", artist, album];
}

#pragma mark Public Methods

- (NSArray*) artists
{
	return [[artistToAlbums allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSArray*) albumsForArtist:(NSString*)anArtist
{
	return [[artistToAlbums valueForKey:anArtist] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSArray*) songsForArtist:(NSString*)anArtist album:(NSString*)anAlbum
{
	return [artistAndAlbumToSimulatorSong valueForKey:[self keyForArtist:anArtist andAlbum:anAlbum]];
}

- (UIImage*) imageForArtist:(NSString*)anArtist album:(NSString*)anAlbum withSize:(CGSize)aSize
{	
	NSString* key = [self keyForArtist:anArtist andAlbum:anAlbum];
	
	NSAssert2(key, @"Could not get key for artists %@ and album %@", anArtist, anAlbum);
	
	if (!key) return nil;
		
	UIImage* image = [imageCache valueForKey:key];
	
	if (!image)
	{
		NSLog(@"Fetching album art for key: %@", key);

		image = [self placeholderAlbumImage];
		
		// Update cache.
		[imageCache setValue:image forKey:key];
		
		// Simulate background load
		UIImage* backgroundLoadedImage = [self simulatorAlbumImage];
		
		// Update the cache and notify listeners that it's changed.
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[imageCache setValue:backgroundLoadedImage forKey:key];
			
			[self postImageCacheUpdatedNotification];
			
		});

	}
	
	return image;
}

#pragma mark Protected Methods

- (void) rememberAlbum:(NSString *)album forArtist:(NSString *)artist 
{	
	NSParameterAssert(artist);
	NSParameterAssert(album);
	
	if (!artist || !album) return;

	NSMutableArray* albums = [artistToAlbums valueForKey:artist];
	if (!albums)
	{
		albums = [NSMutableArray array];
	}
	
	[albums addObject:album];
				  
	[artistToAlbums setValue:albums forKey:artist];
}

- (void) rememberSongs:(NSArray*)songs forArtist:(NSString*)artist andAlbum:(NSString*)album
{
	NSParameterAssert(artist);
	NSParameterAssert(album);
	NSParameterAssert([songs count]);
	
	if (!artist || !album || ![songs count]) return;

	[artistAndAlbumToSimulatorSong setValue:songs forKey:[self keyForArtist:artist andAlbum:album]];
}

- (void) addArtistName:(NSString*)artist albumName:(NSString*)album songNames:(NSArray*)songNames
{
	NSParameterAssert(artist);
	NSParameterAssert(album);
	NSParameterAssert([songNames count]);
	
	if (!artist || !album || ![songNames count]) return;
	
	// Create simulator song objects that we can lookup later by artist and/or album.
	
	NSMutableArray* songs = [[NSMutableArray alloc] initWithCapacity:[songNames count]];
	
	for (NSString* name in songNames)
	{
		SimulatorSong* song = [[SimulatorSong alloc] initWithName:name artist:artist album:album];
		
		if (song)
		{
			[songs addObject:song];
			
			[song release];
		}
	}
	
	if ([songs count])
	{
		[self rememberAlbum:album forArtist:artist];
		
		[self rememberSongs:songs forArtist:artist andAlbum:album];
	}
	
	[songs release];
	
}

- (NSArray*) songs:(const NSUInteger)Count withAlbumPrefix:(NSString*)prefix
{
	NSMutableArray* songTitles = [NSMutableArray arrayWithCapacity:Count];
	
	for (NSUInteger i = 0; i < Count; i++)
	{
		[songTitles addObject:[NSString stringWithFormat:@"%@ song %lu", prefix, i + 1]];
	}
	
	return songTitles;
}

#pragma mark Object Life Cycle

- (id) init
{
	self = [super init];
	if (self != nil) {
		
		artistToAlbums					= [[NSMutableDictionary alloc] init];
		artistAndAlbumToSimulatorSong	= [[NSMutableDictionary alloc] init];
		imageCache						= [[NSMutableDictionary alloc] init];
		
		// Add dummy data for use in the simulator..
		
#if 1
		static NSString* TEST_ARTIST1	= @"Mariah Carey";
		static NSString* TEST_ARTIST2	= @"Sting";
		static NSString* TEST_ARTIST3	= @"Rage Against the Machine";
		static NSString* TEST_ARTIST4	= @"Metallica";

		{
			[self addArtistName:TEST_ARTIST1 albumName:@"Art1-1" songNames:[self songs:8 withAlbumPrefix:@"1"]];
			
			[self addArtistName:TEST_ARTIST1 albumName:@"Art1-2" songNames:[self songs:12 withAlbumPrefix:@"2"]];
			
			[self addArtistName:TEST_ARTIST1 albumName:@"Art1-3" songNames:[self songs:8 withAlbumPrefix:@"3"]];
			
			[self addArtistName:TEST_ARTIST2 albumName:@"Art2-1" songNames:[self songs:12 withAlbumPrefix:@"1"]];
			
			[self addArtistName:TEST_ARTIST2 albumName:@"Art2-2" songNames:[self songs:12 withAlbumPrefix:@"2"]];
			
			[self addArtistName:TEST_ARTIST3 albumName:@"Art3-1" songNames:[self songs:12 withAlbumPrefix:@"1"]];
			
			[self addArtistName:TEST_ARTIST4 albumName:@"Art4-1" songNames:[self songs:3 withAlbumPrefix:@"1"]];
			
			[self addArtistName:TEST_ARTIST4 albumName:@"Art4-2" songNames:[self songs:2 withAlbumPrefix:@"2"]];
			
			[self addArtistName:TEST_ARTIST4 albumName:@"Art4-3" songNames:[self songs:1 withAlbumPrefix:@"3"]];
			
			[self addArtistName:TEST_ARTIST4 albumName:@"Art4-4" songNames:[self songs:12 withAlbumPrefix:@"4"]];
			
			[self addArtistName:TEST_ARTIST4 albumName:@"Art4-5" songNames:[self songs:12 withAlbumPrefix:@"5"]];
			
			[self addArtistName:TEST_ARTIST4 albumName:@"Art4-6" songNames:[self songs:12 withAlbumPrefix:@"6"]];
			
		}
#endif
	}
	return self;
}

- (void) dealloc
{
	[artistToAlbums release];
	[artistAndAlbumToSimulatorSong release];
	[imageCache release];
	
	[super dealloc];
}

+ (MusicLibrary*) sharedInstance
{
	static MusicLibrary* sharedInstance = nil;
	
	if (!sharedInstance)
	{
		sharedInstance = [[SimulatorMusicLibrary alloc] init];
	}
	
	return sharedInstance;
}

@end
