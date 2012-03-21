//
//  Playlist.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "Playlist.h"

#import "Song.h"

@implementation Playlist

#pragma mark Properties

@synthesize name;

- (BOOL) readonly
{
	// Playlists that originate from the Apple Music app are always read-only in iOS 5.
	
	return YES;
}

- (NSArray*) songs
{
	if (!songs)
	{
		songs = [[NSMutableArray alloc] init];
	}
	
	return songs;
}

- (BOOL) isEmpty
{
	return (0 == [self.songs count]);
}

- (NSUInteger) count
{
    return [songs count];
}

#pragma mark Accessors

- (NSMutableSet*) songIDsInPlaylist
{
	if (!songIDsInPlaylist)
	{
		songIDsInPlaylist = [[NSMutableSet alloc] init];
	}
	
	return songIDsInPlaylist;
}
	
- (NSArray*) songIDs
{
    // Note: the order of ids in songIDsInPlaylist is undefined because it's a NSSet.
    // Consequently, we must iterate songs to preserve their natural order.
    
    NSMutableArray* songIdentifiers = [NSMutableArray arrayWithCapacity:[songIDsInPlaylist count]];
    
    for (Song* song in [self songs])
    {
		NSNumber* identifier = [song identifier];
		
		NSParameterAssert(identifier);
		
        if (identifier) [songIdentifiers addObject:identifier];
    }
    
    return songIdentifiers;
}
            
#pragma mark SongCollection Methods

- (id) songCollection
{
	return [self songs];
}

- (id) imageWithSize:(CGSize)aSize
{
	return nil; // Use the system default image for this kind of object.
}

#pragma mark Public Methods

- (BOOL) containsSong:(Song*)aSong
{
	// $$$$$ We should probably keep a list of songIDs in the queue
	// so we're not relying solely on object equality...
	
	return [[self songs] containsObject:aSong];
}

#pragma mark NSObject Methods

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@: %p> { name=%@ songs=%@}", NSStringFromClass([self class]), self, name, [self songs]];
}

#pragma mark Object Life Cycle

- (id) initWithName:(NSString*)aName
{
	// In debug builds, don't proceed any further if we don't have proper parameters for this object.
	
	NSParameterAssert(aName);
	
	// In release builds, if we don't have proper parameters, return nil from the init method to indicate an error
	// creating this object.
	
	if (!aName)
	{
		return nil;
	}
	
	self = [super init];
	if (self != nil) {
		name = [aName copy];
	}
	
	return self;
}

@end
