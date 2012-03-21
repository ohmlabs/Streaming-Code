/*
 
 SimulatorSong.h
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import "SimulatorSong.h"

@implementation SimulatorSong

#pragma mark Properties - Synthesized

@synthesize name;
@synthesize artist;
@synthesize album;

#pragma mark Properties

- (NSString*) identifier
{
	static NSUInteger simulatorSongID = 30000;
	
	if (!identifier)
	{
		identifier = [[[NSNumber numberWithInteger:simulatorSongID++] stringValue] retain];
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

- (id) initWithName:(NSString*)aName artist:(NSString*)anArtist album:(NSString*)anAlbum
{
	NSParameterAssert(aName);
	NSParameterAssert(anArtist);
	NSParameterAssert(anAlbum);
	
	if (!aName || !anArtist || !anAlbum)
	{
		[self release];
		return nil;
	}
	
	self = [super init];
	if (self != nil) {
		name	= [aName retain];
		artist	= [anArtist retain];
		album	= [anAlbum retain];
	}
	return self;
}

-(void) dealloc
{
	[name release];
	[artist release];
	[album release];
	[identifier release];
	
	[super dealloc];
}

@end
