//
//  Artist.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "Artist.h"

@implementation Artist

#pragma mark Properties

@synthesize name;

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

#pragma mark NSObject Methods

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@: %p> { name=%@ }", NSStringFromClass([self class]), self, name];
}

#pragma mark Object Life Cycle

- (id) initWithName:(NSString*)aName
{
	// In debug builds, don't proceed any further if we don't have proper parameters for this object.
	
	NSParameterAssert(aName);
	
	// In release builds, if we don't have proper parameters, return nil from the init method to indicate an error
	// creating this object.
	
	if (!aName)
	{
		return nil;
	}
	
	self = [super init];
	if (self != nil)
	{
		name = [aName copy];
	}
	
	return self;
}

@end
