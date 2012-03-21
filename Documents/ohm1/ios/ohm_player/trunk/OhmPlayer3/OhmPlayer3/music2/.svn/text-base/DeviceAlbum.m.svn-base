//
//  DeviceAlbum.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "DeviceAlbum.h"

#import "DeviceSong.h"
#import "OhmAppearance.h"

@implementation DeviceAlbum

#pragma mark Properties

@synthesize mediaItemCollection;

#pragma mark Album Properties - Overridden

- (NSString*) title
{
    if (!title)
    {
        title = [[mediaItemCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];

        if (![title length]) title = [OhmAppearance defaultAlbumTitle];
    }
    
    return title;
}

- (NSString*) artistName
{
    if (!artistName)
    {
        artistName = [[mediaItemCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumArtist];

        if (![artistName length]) artistName = [OhmAppearance defaultArtistName];
    }
    
    return artistName;
}

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

- (NSArray*) songs
{
	if (!songs)
	{
		songs = [self allocateSongs];
	}
	
	return songs;
}

- (id) imageWithSize:(CGSize)aSize
{    
	if (!cachedImage)
	{
		MPMediaItemArtwork* albumArtwork = [[mediaItemCollection representativeItem] valueForProperty:MPMediaItemPropertyArtwork];
		
		cachedImage = [albumArtwork imageWithSize:aSize];
	}
	
	return cachedImage;
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
		
        NSString* aTitle        = [[mediaItemCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
        NSString* anArtistName  = [[mediaItemCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumArtist];
 		
		//NSMutableArray* allocatedSongs	= [self allocateSongs];
       
        dispatch_async(dispatch_get_main_queue(), ^
                       {
						   // Note: the properties of this object are only computed on the main thread.
						   // If they're already set when this block executes, it OK to overwrite
						   // placeholder names with real names recently fetched from the ipod music library database.
						   
						   // In the case of an array, the array's elements should have the same values,
						   // hence we throw away the most recent superfluous computation in favor preserving
						   // pointer equality comparisons for existing callers.

                           title = aTitle;
                           artistName = anArtistName;
						   
						   //if (!songs) songs = allocatedSongs;
                      });
    });
    
	return self;
}

- (id) init
{
	return [self initWithMediaItemCollection:nil];
}

@end
