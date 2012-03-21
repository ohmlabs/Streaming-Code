//
//  SongCollection.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

// Objects implementing this protocol allow a MusicPlayer object to play
// songs provided in the form of a collection.

// IMPORTANT:
//
// Simulator objects implementing this protocol MUST return an NSArray of Songs objects.
//
// Device objects implementing this protocol MUST return a MPMediaItemCollection object.

@protocol SongCollection <NSObject>

- (id) songCollection;

- (id) imageWithSize:(CGSize)aSize;	// Returns artwork for this song collection, or nil if the caller should use a default.

@end
