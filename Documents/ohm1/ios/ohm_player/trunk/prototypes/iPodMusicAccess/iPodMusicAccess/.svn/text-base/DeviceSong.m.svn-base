//
//  DeviceSong.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "DeviceSong.h"

@implementation DeviceSong

#pragma mark Properties

@synthesize mediaItem;

#pragma mark Object Life Cycle

- (id) initWithMediaItem:(id)aMediaItem
{
	NSParameterAssert(aMediaItem);
	
	NSString* aTitle	= [aMediaItem valueForProperty:MPMediaItemPropertyTitle];
	NSString* anArtist	= [aMediaItem valueForProperty:MPMediaItemPropertyArtist];
	NSString* anAlbum	= [aMediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
	
	if ((self = [self initWithTitle:aTitle artist:anArtist album:anAlbum]))
	{
		mediaItem = aMediaItem;
	}
	
	return self;
}

- (id) init
{
	return [self initWithMediaItem:nil];
}

@end
