//
//  Song.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "Song.h"

#import "OhmAppearance.h"

static const NSTimeInterval SIMULATED_SONG_DURATION	= 15.0; // seconds

static NSString* const PLACEHOLDER_ALBUM_IMAGE_NAME = @"default_album_artwork";

@implementation Song

#pragma mark Properties

@synthesize identifier;

- (NSNumber*) identifier
{	
	if (!identifier)
	{
		NSString* uniqueID = [NSString stringWithFormat:@"%@+%@+%@", title, albumName, artistName];
		
		identifier = [NSNumber numberWithUnsignedInteger:[uniqueID hash]];
		
		// Note: we shouldn't use this implementation for DeviceSong subclasses because we may need to 
		// use the device-specific subclass's mediaItem in device-specific APIs.
	
	}
	
	return identifier;
}

- (NSNumber *) playbackDuration
{
	return [NSNumber numberWithDouble:SIMULATED_SONG_DURATION]; // Note: device specific subclasses MUST override this method.
}

#pragma mark Protected Methods

- (NSString*) title
{
    if (!title)
    {
        title = [OhmAppearance defaultSongTitle];
    }
    
    return title;
}

- (NSString*) artistName
{
    if (!artistName)
    {
        artistName = [OhmAppearance defaultArtistName];
    }
    
    return artistName;
}

- (NSString*) albumName
{
    if (!albumName)
    {
        albumName = [OhmAppearance defaultAlbumTitle];
    }
    
    return albumName;
}

#pragma mark NSObject Methods

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@: %p> { title=%@ artistName=%@ albumName=%@ }", NSStringFromClass([self class]), self, title, artistName, albumName];
}

#pragma mark Public Methods

- (id) imageWithSize:(CGSize)aSize
{
	return [[UIImage imageNamed:PLACEHOLDER_ALBUM_IMAGE_NAME] copy];
}

#pragma mark Object Life Cycle

- (id) initWithTitle:(NSString*)aTitle artist:(NSString*)anArtist album:(NSString*)anAlbum
{
    // Note: music library songs in the wild may have nil titles, artists and/or album names.
    
    self = [super init];
	if (self != nil) {
		title		= [aTitle copy];
		artistName	= [anArtist copy];
		albumName	= [anAlbum copy];
	}
	return self;
}

- (id)init
{
    return [self initWithTitle:nil artist:nil album:nil];
}

@end
