//
//  Album.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SongCollection.h"

// This class represents an album.

@interface Album : NSObject<SongCollection>
{
@protected
	
    NSString* title;
    NSString* artistName;
    
	NSMutableArray* songs;
}

@property (nonatomic, strong, readonly) NSString	*title;
@property (nonatomic, strong, readonly) NSString	*artistName;

@property (nonatomic, strong, readonly) NSArray		*songs;				// All Song objects for this album.

- (id) imageWithSize:(CGSize)aSize;										// Returns artwork for this album.

- (id) initWithTitle:(NSString*)title artistName:(NSString*)artistName;

- (id) init; // Designated initializer.

@end
