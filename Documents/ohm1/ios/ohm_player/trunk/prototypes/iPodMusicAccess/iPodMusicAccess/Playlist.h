//
//  Playlist.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SongCollection.h"

// This class represents a playlist.

@interface Playlist : NSObject<SongCollection>
{
@private
	
	NSMutableArray* songs;
}

@property (nonatomic, strong, readonly) NSString	*name;

@property (nonatomic, strong, readonly) NSArray		*songs;		// All Song objects for this playlist.

- (id) initWithName:(NSString*)name;							// Designated initializer.

@end
