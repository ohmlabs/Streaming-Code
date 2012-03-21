//
//  OhmPlaylistManager.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class manages persistent user created playlists.

// Note: future implementations may download playlists from the network.
// For now, however, the current implementation only loads playlists from
// the local file system.

// Note: User defined playlist names do NOT have to be unique.

@class MutablePlaylist;
@class Playlist;

@interface OhmPlaylistManager : NSObject {
    
@protected
    
    NSMutableArray* playlists;
    
	MutablePlaylist* queue;
	
	BOOL hasLoadedPlaylists;
}

// Returns an array of PersistentPlaylist objects, excluding the user's Queue.
- (NSArray*) persistentPlaylists;

- (MutablePlaylist*) createEmptyPlaylistWithName:(NSString*)name;

- (MutablePlaylist*) copyPlaylist:(Playlist*)playlist withName:(NSString*)name;

+ (MutablePlaylist*) queue;

+ (id) sharedInstance;

- (void) savePlaylists;

@end
