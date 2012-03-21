/*
 
 DeviceSong.m
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import "DeviceSong.h"

#import <MediaPlayer/MediaPlayer.h>

@implementation DeviceSong

#pragma mark Properties - Synthesized

@synthesize name;
@synthesize artist;
@synthesize album;
@synthesize mediaItem;

#pragma mark Properties

- (NSString*) identifier
{	
	if (!identifier)
	{
		identifier = [[mediaItem valueForProperty:MPMediaItemPropertyPersistentID] retain];
	}
	
	return identifier;
}

#pragma mark MusicLibrarySong Methods

#pragma mark NSObject Methods

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@: %p> { name=%@ album=%@ artist=%@}", NSStringFromClass([self class]), self,
			name, album, artist];
}

#pragma mark Object Life Cycle

- (id) initWithName:(NSString*)aName artist:(NSString*)anArtist album:(NSString*)anAlbum mediaItem:(MPMediaItem *)aMediaItem
{
	NSParameterAssert(aName);
	NSParameterAssert(anArtist);
	NSParameterAssert(anAlbum);
	NSParameterAssert(aMediaItem);
	
	if (!aName || !anArtist || !anAlbum || !aMediaItem)
	{
		[self release];
		return nil;
	}
	
	self = [super init];
	if (self != nil) {
		name		= [aName retain];
		artist		= [anArtist retain];
		album		= [anAlbum retain];
		mediaItem	= [aMediaItem retain];
	}
	return self;
}

- (id) initWithMediaItem:(MPMediaItem*)aMediaItem
{
	NSString* aName = [aMediaItem valueForProperty:MPMediaItemPropertyTitle];
	NSString* anArtist = [aMediaItem valueForProperty:MPMediaItemPropertyArtist];
	NSString* anAlbum = [aMediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
	
	return [self initWithName:aName
							artist:anArtist
						album:anAlbum
					mediaItem:aMediaItem];
}

-(void) dealloc
{
	[name release];
	[artist release];
	[album release];
	[identifier release];
	[mediaItem release];
	
	[super dealloc];
}

@end
