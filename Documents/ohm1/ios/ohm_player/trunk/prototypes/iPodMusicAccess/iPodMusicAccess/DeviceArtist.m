//
//  DeviceArtist.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "DeviceArtist.h"

#import "DeviceAlbum.h"
#import "DeviceSong.h"

@implementation DeviceArtist

#pragma mark Properties

@synthesize mediaItemCollection;

#pragma mark Artist Methods - Overridden

- (NSArray*) albums
{			
	NSMutableArray* albums_ = (NSMutableArray*)[super albums];
	
	if (![albums_ count])
	{
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
		
	}
	
	return albums_;
}

- (NSArray*) songs
{
	NSMutableArray* songs_ = (NSMutableArray*)[super songs];
	
	if (![songs_ count])
	{
		for (MPMediaItem* item in [mediaItemCollection items])
		{
			DeviceSong* song = [[DeviceSong alloc] initWithMediaItem:item];
			
			if (song) [songs_ addObject:song];
		}
		
	}
	
	return songs_;
}

#pragma mark Object Life Cycle

- (id) initWithMediaItemCollection:(id)aMediaItemCollection
{
	NSParameterAssert(aMediaItemCollection);
	
	NSString* aName	= [[aMediaItemCollection representativeItem] valueForProperty:MPMediaItemPropertyArtist];
	
	if ((self = [self initWithName:aName]))
	{
		mediaItemCollection = aMediaItemCollection;
	}
	
	return self;
}

- (id) init
{
	return [self initWithMediaItemCollection:nil];
}

@end
