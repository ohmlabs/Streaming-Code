//
//  DeviceSong.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "DeviceSong.h"

#import "OhmAppearance.h"

@implementation DeviceSong

#pragma mark Properties

@synthesize mediaItem;
@synthesize identifier; // NOTE: this declaration hides the base class's identifier property.

- (NSNumber*) identifier
{	
	if (!identifier)
	{
		identifier = [mediaItem valueForProperty:MPMediaItemPropertyPersistentID];
	}
	
	return identifier;
}

- (NSNumber *) playbackDuration
{
	return [mediaItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
}

#pragma mark Public Methods

- (id) imageWithSize:(CGSize)aSize
{
	MPMediaItemArtwork* artwork = [mediaItem valueForProperty:MPMediaItemPropertyArtwork];
	
	return [artwork imageWithSize:aSize];
}

#pragma mark Song Methods - Overridden

- (NSString*) title
{
    if (!title)
    {
        title = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
        
        if (![title length]) title = [OhmAppearance defaultSongTitle];
    }
    
    return title;
}

- (NSString*) artistName
{
    if (!artistName)
    {
        artistName = [mediaItem valueForProperty:MPMediaItemPropertyArtist];
        
        if (![artistName length]) artistName = [OhmAppearance defaultArtistName];
    }
    
    return artistName;
}

- (NSString*) albumName
{
    if (!albumName)
    {
        albumName = [mediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        
        if (![albumName length]) albumName = [OhmAppearance defaultAlbumTitle];
    }
    
    return albumName;
}


#pragma mark Object Life Cycle

- (id) initWithMediaItem:(id)aMediaItem
{
	NSParameterAssert(aMediaItem);
	
	if (!aMediaItem) return nil;
	
	if ((self = [super init]))
	{
		mediaItem = aMediaItem;
	}
	
    // Actively load the media properties in the background for performance reasons.
    // We don't want to wait until we scroll to a corresponding object to compute
    // these properties using [slow] synchronous database accesses to the iPod music library.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^ {
        
		// Note: the ipod music library implementation in iOS 5 appears to be single threaded. In other words,
		// a read request in the background WILL block a read request (at the same priority level) on the main thread.
		// As a result of this observation, there's not much advantage to doing a lot of background work with the
		// iPod music library; it doesn't improve the perceived performance and can actually slow things down on a uni-processor.

        NSString* aTitle        = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
        NSString* anArtistName  = [mediaItem valueForProperty:MPMediaItemPropertyArtist];
        NSString* anAlbumName   = [mediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           title = aTitle;
                           artistName = anArtistName;
                           albumName = anAlbumName;
                       });
    });

	return self;
}

- (id) init
{
	return [self initWithMediaItem:nil];
}

@end
