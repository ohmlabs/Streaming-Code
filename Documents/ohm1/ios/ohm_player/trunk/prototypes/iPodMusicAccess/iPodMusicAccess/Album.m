//
//  Album.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "Album.h"

@implementation Album

#pragma mark Properties

@synthesize title;
@synthesize artistName;

- (NSArray*) songs
{
	if (!songs)
	{
		songs = [[NSMutableArray alloc] init];
	}
	
	return songs;
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

- (id) initWithTitle:(NSString*)aTitle artistName:(NSString*)anArtistName
{
	// In debug builds, don't proceed any further if we don't have proper parameters for this object.
	
	NSParameterAssert(aTitle && anArtistName);
	
	// In release builds, if we don't have proper parameters, return nil from the init method to indicate an error
	// creating this object.
	
	if (!aTitle && !anArtistName)
	{
		return nil;
	}
	
	self = [super init];
	if (self != nil) {
		title		= [aTitle copy];
		artistName	= [anArtistName copy];
	}
	
	return self;
}

@end
