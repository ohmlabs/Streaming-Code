//
//  Song.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "Song.h"

@implementation Song

#pragma mark Properties

@synthesize title, albumName, artistName;

#pragma mark NSObject Methods

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@: %p> { title=%@ artistName=%@ albumName=%@ }", NSStringFromClass([self class]), self, title, artistName, albumName];
}

#pragma mark Object Life Cycle

- (id) initWithTitle:(NSString*)aTitle artist:(NSString*)anArtist album:(NSString*)anAlbum
{
	// In debug builds, don't proceed any further if we don't have proper parameters for creating a song object.
	
	NSParameterAssert(aTitle && anArtist && anAlbum);
	
	// In release builds, if we don't have proper parameters, return nil from the init method to indicate an error
	// creating this song object.
	
	if (!aTitle && !anArtist && !anAlbum)
	{
		return nil;
	}
	
	self = [super init];
	if (self != nil) {
		title		= [aTitle copy];
		artistName	= [anArtist copy];
		albumName	= [anAlbum copy];
	}
	return self;
}

@end
