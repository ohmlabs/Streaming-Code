//
//  SimulatorMusicLibrary.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "SimulatorMusicLibrary.h"

#import "SimulatorArtist.h"
#import "SimulatorAlbum.h"
#import "SimulatorSong.h"
#import "SimulatorPlaylist.h"

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

- (NSArray*) allITunesPlaylists
{
	if (!allITunesPlaylists)
	{
		allITunesPlaylists = [[NSMutableArray alloc] init];
	}
	
	return allITunesPlaylists;
}

- (NSArray*) artistNames
{
	if (!allArtistNames)
	{
		allArtistNames = [[NSMutableArray alloc] init];
		
		for (Artist* artist in [self allArtists])
		{
			NSString* name = artist.name;
			
			if (name)
			{
				[allArtistNames addObject:name];
			}
		}
		
	}
	
	return allArtistNames;
}

- (NSArray*) allArtistSections
{
	return allArtistSections;
}

- (NSArray*) allAlbumSections
{
	return allAlbumSections;
}

- (Song*) songForSongID:(NSNumber*)songID
{
	NSString* key = [songID stringValue];

	return (key) ? [idsToSongs valueForKey:key] : nil;
}

#pragma mark SongCollection Methods

- (id) songCollection
{
	return [self allSongs];
}

- (id) imageWithSize:(CGSize)aSize
{
	return nil; // Use the system default image for this kind of object.
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
				
		NSString* key = [[song identifier] stringValue];
		
		[idsToSongs setValue:song forKey:key];
	}
	
	return song;
}

- (NSArray*) setUpObjectTableIndexSectionsForArray:(NSArray*)array withCollationStringSelector:(SEL)sel
{
	// Returns an array of arrays. The outer array corresponding
	// to a UILocalizedCollation sectionTitle and the inner array
	// corresponding to an Artist or Album object.
	
	if (![array count])
	{
		return nil;
	}
	
	UILocalizedIndexedCollation* collation = [UILocalizedIndexedCollation currentCollation];
	
	if (!collation) return nil;
	
	// Create an empty [placeholder] section array for each index section.
	
	const NSUInteger OUTER_ARRAY_SIZE = [[collation sectionIndexTitles] count];
	
	NSMutableArray* outerArray = [NSMutableArray arrayWithCapacity:OUTER_ARRAY_SIZE];
	
	for (NSUInteger i = 0; i < OUTER_ARRAY_SIZE; i++)
	{
		[outerArray addObject:[NSMutableArray array]];
	}
	
	// Assign an object to each section.
	
	for (id obj in array)
	{
		const NSUInteger sectionNumber = [collation sectionForObject:obj collationStringSelector:sel];
		
		NSMutableArray* sectionArray = [outerArray objectAtIndex:sectionNumber];
		
		[sectionArray addObject:obj];
	}
	
	// Sort each subsection array.
	
	for (NSUInteger sectionNumber = 0; sectionNumber < OUTER_ARRAY_SIZE; sectionNumber++)
	{
		NSMutableArray* sectionArray = [outerArray objectAtIndex:sectionNumber];
		
		if (sectionArray)
		{
			NSArray* sortedSectionArray = [collation sortedArrayFromArray:sectionArray collationStringSelector:sel];
			
			if (sortedSectionArray)
			{
				[outerArray replaceObjectAtIndex:sectionNumber withObject:sortedSectionArray];
			}
		}
		
	}
			
	return outerArray;
}

- (void) setUpAlbumTableIndexSections
{
	allAlbumSections = [self setUpObjectTableIndexSectionsForArray:[self allAlbums] withCollationStringSelector:@selector(title)];
}

- (void) setUpArtistTableIndexSections
{
	allArtistSections = [self setUpObjectTableIndexSectionsForArray:[self allArtists] withCollationStringSelector:@selector(name)];
}

- (void) setUpImmutablePlaylists
{
	NSMutableArray* list = (NSMutableArray*)self.allITunesPlaylists;
	
	NSParameterAssert(list);
	
	const NSUInteger COUNT = 8;
	
	for (NSUInteger i = 0 ; i < COUNT; i++)
	{
		if ([[self allSongs] count] > i)
		{
			SimulatorPlaylist* playlist = [[SimulatorPlaylist alloc] initWithName:[NSString stringWithFormat:@"List %ld", (long)i]];
			
			[playlist addSong:[[self allSongs] objectAtIndex:i]];

			[list addObject:playlist];
		}
				
	}
	
}

- (void) setUpMusicLibrary
{
	// A bit of a hack, but it works :-)
	
	struct ArtistAlbumInfo_t
	{
		const char* const artistName; const int* albumSongCounts;
	};
	
	// IMPORTANT: These arrays MUST be 0 terminated!
	
	const int artistAlbumCounts1[] = {8, 12, 8, 0};
	const int artistAlbumCounts2[] = {12, 12, 0};
	const int artistAlbumCounts3[] = {12, 0};
	const int artistAlbumCounts4[] = {3, 2, 1, 12, 12, 12, 0};
	
	// IMPORTANT: The artist below MUST be sorted!
	
	struct ArtistAlbumInfo_t c_artistAlbumInfos[] = {
		{ "Kanye West", artistAlbumCounts1},
		{ "Metallica", artistAlbumCounts4},
		{ "Rage Against the Machine", artistAlbumCounts3},
		{ "Sting", artistAlbumCounts2},
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
		
		artistNumber++;
		
	}

	[self setUpAlbumTableIndexSections];
	[self setUpArtistTableIndexSections];

	[self setUpImmutablePlaylists];
}

#pragma mark Indexed TableView Support

- (NSUInteger) numberOfSectionsForArtists
{
	return [[self allArtistSections] count];
}

- (NSUInteger) numberOfSectionsForAlbums
{
	return [[self allAlbumSections] count];
}

- (NSUInteger) numberOfRowsForArtistSection:(NSUInteger)section
{
	NSArray* sectionArray = [[self allArtistSections] objectAtIndex:section];
	
	return [sectionArray count];
}

- (NSUInteger) numberOfRowsForAlbumSection:(NSUInteger)section
{
	NSArray* sectionArray = [[self allAlbumSections] objectAtIndex:section];
		
	return [sectionArray count];
}

- (Artist*) artistAtIndexPath:(NSIndexPath*)indexPath
{
	if (!indexPath) return nil;
    
    const NSInteger row		= [indexPath row];
	const NSInteger section = [indexPath section];
	
	if ((row >= 0) && (section >= 0))
	{
		NSArray* sectionArray = [[self allArtistSections] objectAtIndex:section];
		
		return [sectionArray objectAtIndex:row];
	}
	
	return nil;
}

- (NSUInteger) nearestTableViewSectionForArtistCharacterIndexSection:(NSUInteger)selectedCharacterIndexSection
{    
    // Returns the first non-empty tableview section at or after characterIndexSection.
    // If not found, returns the last non-empty section.
            
    const NSUInteger SectionCount = [[self allArtistSections] count];
        
    for (NSUInteger i = selectedCharacterIndexSection; i < SectionCount; i++)
    {
        NSArray* sectionArray = [[self allArtistSections] objectAtIndex:i];
        
        if ([sectionArray count])
        {            
            return i;
        }
                
    }
    
    // We didn't return above, so we didn't find a match.
    // Return the last known non-empty index by walking backwards...
    
    for (NSUInteger i = selectedCharacterIndexSection; i > 0; i--)
    {
        NSArray* sectionArray = [[self allArtistSections] objectAtIndex:i];
        
        if ([sectionArray count])
        {            
            return i;
        }
        
    }

    return NSNotFound;
}

- (Album*) albumAtIndexPath:(NSIndexPath*)indexPath
{
	const NSInteger row		= [indexPath row];
	const NSInteger section = [indexPath section];
	
	if ((row >= 0) && (section >= 0))
	{
		NSArray* sectionArray = [[self allAlbumSections] objectAtIndex:section];
		
		return [sectionArray objectAtIndex:row];
	}
	
	return nil;
}

- (NSString*) titleForHeaderInArtistSection:(NSUInteger)section
{
	NSArray* sectionArray = [[self allArtistSections] objectAtIndex:section];
	
	return ([sectionArray count])
	? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section]
	: nil;
}

- (NSString*) titleForHeaderInAlbumSection:(NSUInteger)section
{
	NSArray* sectionArray = [[self allAlbumSections] objectAtIndex:section];
	
	return ([sectionArray count])
	? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section]
	: nil;
}

#pragma mark Object Life Cycle

- (id) init
{
	self = [super init];
	if (self != nil)
	{
		idsToSongs = [NSMutableDictionary dictionary];
		
		[self setUpMusicLibrary];
	}
	
	return self;
}

+ (MusicLibrary*) sharedInstance
{
	static id sharedInstance = nil;
	
    if (sharedInstance) return sharedInstance;
    
	@synchronized (self)
    {
        if (!sharedInstance)
        {
            sharedInstance = [[SimulatorMusicLibrary alloc] init];
        }
    }
    
	return sharedInstance;
}

@end
