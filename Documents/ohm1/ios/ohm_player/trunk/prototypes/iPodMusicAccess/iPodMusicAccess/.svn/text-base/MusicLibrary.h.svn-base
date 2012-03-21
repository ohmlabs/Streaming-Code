//
//  MusicLibrary.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Artist.h"
#import "Album.h"
#import "Song.h"

#import "SongCollection.h"

// This protocol abstracts the user's music library.

@protocol MusicLibrary <NSObject, SongCollection>

// Returns an array of Artist objects.
- (NSArray*) allArtists;

// Returns an array of Album objects.
- (NSArray*) allAlbums;

// Returns an array of Song objects.
- (NSArray*) allSongs;

#pragma mark SongCollection Methods

// Note: a MusicLibrary object implements the SongCollection protocol so that all of its
// contained songs can be represented as a single collection to a MusicPlayer.

// IMPORTANT:
//
// Simulator objects implementing this protocol MUST return an NSArray of Songs objects.
//
// Device objects implementing this protocol MUST return a MPMediaItemCollection object.

- (id) songCollection;

@end

#pragma mark Music Library Functions

// This function returns a music library implementation appropriate for use in the iOS Simulator
// or on an iOS device depending on the compilation target.

typedef NSObject<MusicLibrary> MusicLibrary;

MusicLibrary* musicLibrary(void);
