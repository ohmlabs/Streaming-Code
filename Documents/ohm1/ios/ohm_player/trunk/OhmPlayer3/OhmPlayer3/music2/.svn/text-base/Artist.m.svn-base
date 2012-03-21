//
//  Artist.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "Artist.h"

#import "Album.h"
#import "Song.h"
#import "OhmAppearance.h"

static NSString* const ALL_SONGS_ARTWORK_NAME = @"AllSongs";

@implementation Artist

#pragma mark Properties

- (NSString*) name
{
    if (!name)
    {
        name = [OhmAppearance defaultArtistName];
    }
    
    return name;
}

- (NSArray*) albums
{
	if (!albums)
	{
		albums = [[NSMutableArray alloc] init];
	}
	
	return albums;
}

- (NSArray*) songs
{
	if (!songs)
	{
		songs = [[NSMutableArray alloc] init];
	}
	
	return songs;
}

- (NSArray*) songNames
{
	if (!songNames)
    {
        songNames = [NSMutableArray array];
	
        for (Song* song in [self songs])
        {
            NSString* title = song.title;
            
            if (title)
            {
                [songNames addObject:title];
            }
        }
	}
    
	return songNames;
}

- (NSArray*) albumNames
{
    if (!albumNames)
    {
        albumNames = [NSMutableArray array];
        
        for (NSObject<SongCollection>* songCollection in [self albums])
        {
            NSString* title = nil;

            if ([songCollection respondsToSelector:@selector(title)])
            {
                title = [(id)songCollection title];
            }
            else if (songCollection == self)
            {
                title = NSLocalizedString(@"All Songs", @"All Songs");
            }
            
            if (title)
            {
                [albumNames addObject:title];
            }
        }
	
    }
    
	return albumNames;
}

#pragma mark SongCollection Methods

- (id) songCollection
{
	return [self songs];
}

- (id) imageWithSize:(CGSize)aSize
{
	static UIImage* sharedArtwork = nil;

	if (!sharedArtwork)
	{
		sharedArtwork = [UIImage imageNamed:ALL_SONGS_ARTWORK_NAME];
	}
	
	return sharedArtwork;
}

#pragma mark NSObject Methods

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@: %p> { name=%@ }", NSStringFromClass([self class]), self, name];
}

#pragma mark Object Life Cycle

- (id) initWithName:(NSString*)aName
{
	self = [super init];
	if (self != nil)
	{
		name = [aName copy];
	}
	
	return self;
}

- (id)init
{
    return [self initWithName:nil];
}

@end
