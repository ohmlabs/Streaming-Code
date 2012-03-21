//
//  People.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

// Represents a list of Person objects.

@class Person;

@interface People : NSObject
{
	NSMutableArray* persons;
	
	NSMutableArray* channelsCache, *whatsHotCache;
}

+ (People*) sharedInstance;

// Returns all people the user is following.
- (NSArray*) people;

// Returns all people that have active live channels.
- (NSArray*) channels;

// Returns all people that are designated hot.
- (NSArray*) whatsHot;

@end
