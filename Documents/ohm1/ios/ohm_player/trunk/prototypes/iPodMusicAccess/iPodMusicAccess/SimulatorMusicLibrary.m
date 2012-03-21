//
//  SimulatorMusicLibrary.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "SimulatorMusicLibrary.h"

#import "SimulatorArtist.h"
#import "SimulatorAlbum.h"
#import "SimulatorSong.h"

#pragma mark AlbumInfo

@interface SimulatorAlbumInfo : NSObject

@property (nonatomic, strong) NSString* artistName;
@property (nonatomic, strong) NSArray* albumSongCounts; // An array of NSNumbers.

- (id) initWithName:(NSString*)artistName songCounts:(const int* const)songCounts;

@end

@implementation SimulatorAlbumInfo

@synthesize artistName;
@synthesize albumSongCounts;

- (id) initWithName:(NSString*)anArtistName songCounts:(const int* const)songCounts
{
	NSParameterAssert(anArtistName);
	NSParameterAssert(songCounts && *songCounts);
	
	if (self = [super init])
	{
		artistName = anArtistName;
		
		NSMutableArray* counts = [NSMutableArray array];
		
		for (const int* cursor = songCounts; *cursor; cursor++)
		{
			[counts addObject:[NSNumber numberWithInt:*cursor]];
		}
		
		albumSongCounts = [counts copy];
	}
	
	return self;
}

- (id) init
{
	return [self initWithName:nil songCounts:NULL];
}

@end

#pragma mark SimulatorMusicLibrary

@implementation SimulatorMusicLibrary

#pragma mark MusicLibrary Methods

- (NSArray*) allArtists
{
	if (!allArtists)
	{
		allArtists = [[NSMutableArray alloc] init];
	}
	
	return allArtists;
}

- (NSArray*) allAlbums
{
	if (!allAlbums)
	{
		allAlbums = [[NSMutableArray alloc] init];
	}
	
	return allAlbums;
}

- (NSArray*) allSongs
{
	if (!allSongs)
	{
		allSongs = [[NSMutableArray alloc] init];
	}
	
	return allSongs;
}

#pragma mark SongCollection Methods

- (id) songCollection
{
	return [self allSongs];
}

#pragma mark Protected Methods

- (SimulatorArtist*) addSimulatorArtist:(SimulatorArtist*)artist
{
	if (artist)
	{
		[(NSMutableArray*)[self allArtists] addObject:artist];
	}
	
	return artist;
}


- (SimulatorAlbum*) addSimulatorAlbum:(SimulatorAlbum*)album
{
	if (album)
	{
		[(NSMutableArray*)[self allAlbums] addObject:album];
	}
	
	return album;
}

- (SimulatorSong*) addSimulatorSong:(SimulatorSong*)song
{
	if (song)
	{
		[(NSMutableArray*)[self allSongs] addObject:song];
	}
	
	return song;
}

- (void) setUpMusicLibrary
{
	// A bit of a hack, but it works :-)
	
	struct ArtistAlbumInfo_t
	{
		const char* const artistName; const int* albumSongCounts;
	};
	
	// IMPORTANT: These arrays must be 0 terminated.
	
	const int artistAlbumCounts1[] = {8, 12, 8, 0};
	const int artistAlbumCounts2[] = {12, 12, 0};
	const int artistAlbumCounts3[] = {12, 0};
	const int artistAlbumCounts4[] = {3, 2, 1, 12, 12, 12, 0};
	
	struct ArtistAlbumInfo_t c_artistAlbumInfos[] = {
		{ "Mariah Carey", artistAlbumCounts1},
		{ "Sting", artistAlbumCounts2},
		{ "Rage Against the Machine", artistAlbumCounts3},
		{ "Metallica", artistAlbumCounts4}
	};
	
	const NSUInteger countOfAlbumInfos = sizeof(c_artistAlbumInfos) / sizeof(struct ArtistAlbumInfo_t);
	
	NSMutableArray* artistInfos = [NSMutableArray array];
	
	for (NSUInteger i = 0; i < countOfAlbumInfos; i++)
	{
		SimulatorAlbumInfo* info = 
		[[SimulatorAlbumInfo alloc] initWithName:[NSString stringWithUTF8String:c_artistAlbumInfos[i].artistName]
									  songCounts:c_artistAlbumInfos[i].albumSongCounts];
		
		if (info) [artistInfos addObject:info];
	}
	
	NSUInteger artistNumber = 0;
	
	for (SimulatorAlbumInfo* info in artistInfos)
	{
		// Create the artist.
		
		SimulatorArtist* artist = [self addSimulatorArtist:[[SimulatorArtist alloc] initWithName:info.artistName]];
		{		
			// Add albums to the artist.
			
			const NSUInteger albumCount = [[info albumSongCounts] count];
			
			for (NSUInteger albumNumber = 0; albumNumber < albumCount; albumNumber++)
			{
				NSString* albumTitle = [NSString stringWithFormat:@"Art%ld-%ld", artistNumber + 1, albumNumber + 1];
				
				SimulatorAlbum* album = [self addSimulatorAlbum:[[SimulatorAlbum alloc] initWithTitle:albumTitle artistName:artist.name]];
				
				// For each ablum, add songs.
				
				const NSUInteger SongCount = [[[info albumSongCounts] objectAtIndex:albumNumber] unsignedIntegerValue];
				
				for (NSUInteger songNumber = 0; songNumber < SongCount; songNumber++)
				{
					NSString* songTitle = [NSString stringWithFormat:@"%ld song %ld", albumNumber + 1, songNumber + 1];
					[album addSimulatorSong:[self addSimulatorSong:[[SimulatorSong alloc] initWithTitle:songTitle artist:artist.name album:album.title]]];
				}
				
				[artist addSimulatorAlbum:album];
				
			}
			
		}
		
	}

}

#pragma mark Object Life Cycle

- (id) init
{
	self = [super init];
	if (self != nil)
	{
		[self setUpMusicLibrary];
	}
	
	return self;
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
