//
//  MutablePlaylist.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "Playlist.h"

@class Song;
@class Album;

// This class represents a mutable playlist.

@interface MutablePlaylist : Playlist

- (void) addSong:(Song*)song;

- (void) addSongsForAlbum:(Album*)song;

@end
