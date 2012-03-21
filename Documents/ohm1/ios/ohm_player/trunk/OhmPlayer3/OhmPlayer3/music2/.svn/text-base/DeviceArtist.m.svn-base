//
//  DeviceArtist.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "DeviceArtist.h"

#import "DeviceAlbum.h"
#import "DeviceSong.h"
#import "OhmAppearance.h"

@implementation DeviceArtist

#pragma mark Properties

@synthesize mediaItemCollection;

#pragma mark Protected Methods

- (NSMutableArray*) allocateSongs
{
	NSMutableArray* songs_ = [[NSMutableArray alloc] init];
	
	for (MPMediaItem* item in [mediaItemCollection items])
	{
		DeviceSong* song = [[DeviceSong alloc] initWithMediaItem:item];
		
		if (song) [songs_ addObject:song];
	}
	
	return songs_;
}

- (NSMutableArray*) allocateAlbums
{
	NSMutableArray* albums_ = [[NSMutableArray alloc] init];
	
	MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
	
	MPMediaPropertyPredicate *artistNamePredicate =
	[MPMediaPropertyPredicate predicateWithValue: self.name
									 forProperty: MPMediaItemPropertyArtist];
	
	[albumsQuery addFilterPredicate: artistNamePredicate];
	
	for (MPMediaItem* item in [albumsQuery collections])
	{
		DeviceAlbum* album = [[DeviceAlbum alloc] initWithMediaItemCollection:item];
		
		if (album) [albums_ addObject:album];
	}
	
	if ([albums_ count] > 1)
	{
		// If there's more than one album, add a synthetic "All Songs" album...
		
		[albums_ insertObject:self atIndex:0];
	}
	
	return albums_;
}

#pragma mark Artist Methods - Overridden

- (NSString*) name
{
    if (!name)
    {
        name = [[mediaItemCollection representativeItem] valueForProperty:MPMediaItemPropertyArtist];
        
        if (![name length]) name = [OhmAppearance defaultArtistName];
    }
    
    return name;
}

- (NSArray*) albums
{
	if (!albums)
	{
		albums = [self allocateAlbums];
	}
	
	return albums;
}

- (NSArray*) songs
{
	if (!songs)
	{
		songs = [self allocateSongs];
	}
	
	return songs;
}

#pragma mark SongCollection Methods

- (id) songCollection
{
	return [[MPMediaItemCollection alloc] initWithItems:mediaItemCollection.items];
}

#pragma mark Object Life Cycle

- (id) initWithMediaItemCollection:(id)aMediaItemCollection
{
	NSParameterAssert(aMediaItemCollection);
	
	if ((self = [super init]))
	{
		mediaItemCollection = aMediaItemCollection;
	}
	
    // Actively load the media properties in the background for performance reasons.
    // We don't want to wait until we scroll to a corresponding object to compute
    // these properties using [slow] synchronous database accesses to the iPod music library.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^ {
        
		// Note: the ipod music library implementation in iOS 5 appears to be single threaded. In other words,
		// a read request in the background WILL block a read request (at the same priority level) on the main thread.
		// As a result of this observation, there's not much advantage to doing a lot of background work with the
		// iPod music library; it doesn't improve the perceived performance and can actually slow things down on a uni-processor.

        NSString* aName = [[mediaItemCollection representativeItem] valueForProperty:MPMediaItemPropertyArtist];
        
		//NSMutableArray* allocatedSongs	= [self allocateSongs];
		//NSMutableArray* allocatedAlbums = [self allocateAlbums];

        if ([aName length])
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
							   // Note: the properties of this object are only computed on the main thread.
							   // If they're already set when this block executes, we might want to overwrite
							   // placeholder names with real names fetched from the ipod music library database.
							   
							   // In the case of an array, the array's elements should have the same values,
							   // hence we throw away the most recent superfluous computation in favor preserving
							   // pointer equality comparisons for existing callers.

							   name = aName;
							   
							   //if (!albums) albums = allocatedAlbums;
							   
							   //if (!songs) songs = allocatedSongs;
                           });
        }
    });
    
	return self;
}

- (id) init
{
	return [self initWithMediaItemCollection:nil];
}

@end
