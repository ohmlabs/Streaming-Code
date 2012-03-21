//
//  PersistentPlaylist.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MutablePlaylist.h"

// This class represents a persistent user created playlist.

// It differs from its base class mutable playlist in that it
// is instantiated from a property list that contains
// an array of persistent song identifiers. Note: not every
// persistent song identifier may correspond to an existing
// MPMediaItem on the device if a previously saved song
// has been removed from the user's music library.

@interface PersistentPlaylist : MutablePlaylist {

	NSMutableDictionary* state;
}

@property (nonatomic, strong, readonly) NSString	*name;

@property (nonatomic, strong, readonly) NSString	*filename;

@property (nonatomic, assign, readonly) BOOL isQueue;

- (id) initWithMemento:(NSDictionary*)memento; // Designated initializer.

- (id) initWithPlaylist:(Playlist*)otherPlaylist;

- (id) initWithName:(NSString*)name;

- (NSDictionary*) memento;

// Returns a special memento used to instantiate an empty queue.
+ (NSDictionary*) queueMemento;

@end
