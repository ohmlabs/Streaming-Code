//
//  Album.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "Album.h"

#import "OhmAppearance.h"

static NSString* const PLACEHOLDER_ALBUM_IMAGE_NAME = @"default_album_artwork";

@implementation Album

#pragma mark Properties

- (NSString*) title
{
    if (!title)
    {
        title = [OhmAppearance defaultAlbumTitle];
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

- (NSArray*) songs
{
	if (!songs)
	{
		songs = [[NSMutableArray alloc] init];
	}
	
	return songs;
}

#pragma mark Public Methods

- (id) imageWithSize:(CGSize)aSize
{
	return [[UIImage imageNamed:PLACEHOLDER_ALBUM_IMAGE_NAME] copy];
}

#pragma mark SongCollection Methods

- (id) songCollection
{
	return [self songs];
}

#pragma mark NSObject Methods

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@: %p> { title=%@ artistName=%@ }", NSStringFromClass([self class]), self, title, artistName];
}

#pragma mark Object Life Cycle

- (id) initWithTitle:(NSString*)aTitle artistName:(NSString*)anArtist
{
    // Note: music library albums in the wild may have nil title and/or artist names.
    
	self = [super init];
	if (self != nil) {
		title		= [aTitle copy];
		artistName	= [anArtist copy];
	}
	
	return self;
}

- (id)init
{
    return [self initWithTitle:nil artistName:nil];
}

@end
