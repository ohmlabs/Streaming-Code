//
//  SimulatorMusicLibrary.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MusicLibrary.h"

// This class represents a simulated music library.

@interface SimulatorMusicLibrary : NSObject<MusicLibrary>
{
@private
	
	NSMutableArray* allAlbums;
	NSMutableArray* allArtists;
	NSMutableArray* allSongs;
	NSMutableArray* allITunesPlaylists;

	NSMutableArray* allArtistNames;
	
	NSArray* allArtistSections;
	NSArray* allAlbumSections;
	
	NSMutableDictionary* idsToSongs; // maps persistent song identifiers to song objects...
}

// Returns an array of Artist objects.
- (NSArray*) allArtists;

// Returns an array of Album objects.
- (NSArray*) allAlbums;

// Returns an array of Song objects.
- (NSArray*) allSongs;

// Returns an array of Playlist objects.
- (NSArray*) allITunesPlaylists;

+ (MusicLibrary*) sharedInstance;

@end
