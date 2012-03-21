//
//  MutablePlaylist.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "Playlist.h"

@class Song;
@class Album;

// This class represents an abstract mutable playlist.

// Note: Although iOS 5 doesn't support mutable playlists, the
// simulator needs this functionality to create read-only playlists...

@interface MutablePlaylist : Playlist

- (void) addSong:(Song*)song;

- (void) addSongsForAlbum:(Album*)song;

@end
