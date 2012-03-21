/*
 
 DeviceMusicLibrary.m
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import "DeviceMusicLibrary.h"

#import <MediaPlayer/MediaPlayer.h>

#import "DeviceSong.h"

NSString* const MusicLibraryImageCacheUpdatedNotification = @"MusicLibraryImageCacheUpdatedNotification";

#define DEBUG_LOG 0

#if DEBUG_LOG

static void dumpMediaItem(MPMediaItem* mediaItem)
{
	NSLog(@"---");
	NSLog(@"%@ %@", MPMediaItemPropertyAlbumArtist, [mediaItem valueForProperty:MPMediaItemPropertyAlbumArtist]);
	NSLog(@"%@ %@", MPMediaItemPropertyAlbumTitle, [mediaItem valueForProperty:MPMediaItemPropertyAlbumTitle]);
	NSLog(@"%@ %@", MPMediaItemPropertyTitle, [mediaItem valueForProperty:MPMediaItemPropertyTitle]);
	NSLog(@"%@ %@", MPMediaItemPropertyMediaType, [mediaItem valueForProperty:MPMediaItemPropertyMediaType]);
}

static void dumpMediaItemArray(NSArray* mediaItems)
{
	for (MPMediaItem* mediaItem in mediaItems)
	{
		dumpMediaItem(mediaItem);
	}
	
}
#endif

static NSString* const PLACEHOLDER_ALBUM_IMAGE_NAME = @"Vault-albumPlaceholder";

@implementation DeviceMusicLibrary

#pragma mark Protected Methods

- (void) postImageCacheUpdatedNotification
{
	[[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:MusicLibraryImageCacheUpdatedNotification object:nil] postingStyle:NSPostWhenIdle];
}

- (UIImage*) placeholderAlbumImage
{
	static UIImage* placeholderImage = nil;
	
	if (!placeholderImage)
	{
		placeholderImage = [[UIImage imageNamed:PLACEHOLDER_ALBUM_IMAGE_NAME] copy];
	}
	
	return placeholderImage;
}

- (NSString*) keyForArtist:(NSString*)artist andAlbum:(NSString*)album
{
	NSParameterAssert(artist);
	NSParameterAssert(album);
	
	if (!artist || !album) return nil;
	
	return [NSString stringWithFormat:@"%@+%@", artist, album];
}

- (NSArray*) albumMediaItemsForArtist:(NSString*)anArtist
{
	NSParameterAssert(anArtist);
	
	if (!anArtist) return nil;
	
	MPMediaPropertyPredicate *artistNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue: anArtist
                                     forProperty: MPMediaItemPropertyArtist];
	
	MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
	
	[albumsQuery addFilterPredicate: artistNamePredicate];
	
	return [albumsQuery collections];
}

- (NSArray*) songsMediaItemsForArtist:(NSString*)anArtist album:(NSString*)anAlbum
{
	NSParameterAssert(anArtist);
	NSParameterAssert(anAlbum);
	
	if (!anArtist || !anAlbum) return nil;
	
	MPMediaPropertyPredicate *artistNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue: anArtist
                                     forProperty: MPMediaItemPropertyArtist];

	MPMediaPropertyPredicate *albumNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue: anAlbum
                                     forProperty: MPMediaItemPropertyAlbumTitle];

	MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
	
	[songsQuery addFilterPredicate: artistNamePredicate];
	[songsQuery addFilterPredicate: albumNamePredicate];
	
	NSArray* songs = [songsQuery items];
	
#if DEBUG_LOG
	NSLog(@"songs = %@", songs);
	dumpMediaItemArray(songs);
#endif
	
	return songs;
}

- (UIImage*) loadAlbumImageForArtist:(NSString*)anArtist album:(NSString*)anAlbum withSize:(CGSize)aSize
{
	NSParameterAssert(anArtist);
	NSParameterAssert(anAlbum);
	
	if (!anArtist || !anAlbum) return nil;

	MPMediaPropertyPredicate *artistNamePredicate =
	[MPMediaPropertyPredicate predicateWithValue: anArtist
									 forProperty: MPMediaItemPropertyArtist];
	
	MPMediaPropertyPredicate *albumNamePredicate =
	[MPMediaPropertyPredicate predicateWithValue: anAlbum
									 forProperty: MPMediaItemPropertyAlbumTitle];
	
	MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
	
	[albumsQuery addFilterPredicate: artistNamePredicate];
	[albumsQuery addFilterPredicate: albumNamePredicate];
	
	NSArray* albums = [albumsQuery collections];
	
	NSAssert1(([albums count] == 1), @"Not exactly one album for artist %@!", anArtist);
	
	if (!([albums count] == 1)) return nil;
	
	MPMediaItem* represenativeAlbum = [[albums objectAtIndex:0] representativeItem];
	
	MPMediaItemArtwork* albumArtwork = [represenativeAlbum valueForProperty:MPMediaItemPropertyArtwork];
	
	return [albumArtwork imageWithSize:aSize];
}

- (UIImage*) imageForArtist:(NSString*)anArtist album:(NSString*)anAlbum withSize:(CGSize)aSize
{	
	NSString* key = [self keyForArtist:anArtist andAlbum:anAlbum];
	
	NSAssert2(key, @"Could not get key for artists %@ and album %@", anArtist, anAlbum);
	
	if (!key) return nil;
		
	UIImage* image = [imageCache valueForKey:key];
	
	if (!image)
	{
		NSLog(@"Fetching album art for key: %@", key);

		// Update the cache with a placeholder image.
		
		image = [self placeholderAlbumImage];
		
		[imageCache setValue:image forKey:key];
		
		// If we didn't originally find a cached image, load one in the background.
		
		// Note: dispatch_async executes a block in a background thread.
		// The block below will load the image in the background and notify the main thread
		// that the image cache has changed. When the main thread receives the notifcation
		// it should reload images for the currently displayed cells.	
		dispatch_async(dispatch_get_global_queue(0, 0), ^{
				
			UIImage* backgroundLoadedImage = [self loadAlbumImageForArtist:anArtist album:anAlbum withSize:aSize];
			
			if (backgroundLoadedImage)
			{
				// Update the cache on the main thread.
				
				dispatch_async(dispatch_get_main_queue(), ^{
					
					[imageCache setValue:backgroundLoadedImage forKey:key];
					
					[self postImageCacheUpdatedNotification];
				});

			}
		});
	
	}
	
	return image;
}

#pragma mark Public Methods

- (NSArray*) artists
{
	if (!artists)
	{
		NSArray* collections = [MPMediaQuery artistsQuery].collections;
	
		NSMutableArray* names = [NSMutableArray arrayWithCapacity:[collections count]];

		for (MPMediaItemCollection* collection in collections)
		{
			NSString* artist = [[collection representativeItem] valueForProperty:MPMediaItemPropertyArtist];

			if (artist) [names addObject:artist];
		}
		
		artists = [names retain];
	}
	
	return artists;
}

- (NSArray*) albumsForArtist:(NSString*)anArtist
{
	NSArray* collection = [self albumMediaItemsForArtist:anArtist];
	
	NSMutableArray* names = [NSMutableArray arrayWithCapacity:[collection count]];
	
	for (MPMediaItemCollection* item in collection)
	{
		NSString* name = [[item representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
		
#if DEBUG_LOG
		NSLog(@"name = %@", name);
#endif
		
		if (name) [names addObject:name];
	}
	
	return names;
}

- (NSArray*) songsForArtist:(NSString*)anArtist album:(NSString*)anAlbum
{
	// $$$$$ PERFORMANCE: It's very slow creating a device song array everytime we scroll :-(
	
	NSArray* collection = [self songsMediaItemsForArtist:anArtist album:anAlbum];
	
	NSMutableArray* songs = [NSMutableArray arrayWithCapacity:[collection count]];
	
	for (MPMediaItem* item in collection)
	{				
		DeviceSong* song = [[DeviceSong alloc] initWithMediaItem:item];

		if (song)
		{
			[songs addObject:song];
			
			[song release];
		}
		
	}
	
	return songs;
}

#pragma mark Object Life Cycle

+ (MusicLibrary*) sharedInstance
{
	static MusicLibrary* sharedInstance = nil;
	
	if (!sharedInstance)
	{
		sharedInstance = [[DeviceMusicLibrary alloc] init];
	}
	
	return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        imageCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [artists release];
	[imageCache release];
	
    [super dealloc];
}

@end
