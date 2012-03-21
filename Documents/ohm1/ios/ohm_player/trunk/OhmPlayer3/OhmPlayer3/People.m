//
//  People.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "People.h"

#import "Person.h"

@implementation People

#pragma mark Protected Methods

- (BOOL) personIsHot:(Person*)person
{
	return person.isHot;
}

- (BOOL) personHasLiveChannel:(Person*)person
{
	return person.hasLiveChannel;
}

#pragma mark Public Methods

- (NSArray*) people
{
	return persons;
}

- (NSArray*) channels
{
	if (!channelsCache)
	{
		channelsCache = [[NSMutableArray alloc] init];
		
		for (Person* person in self.people)
		{
			if ([self personHasLiveChannel:person])
			{
				[channelsCache addObject:person];
			}
		}
	}
	
	return channelsCache;
}

- (NSArray*) whatsHot
{
	if (!whatsHotCache)
	{
		whatsHotCache = [[NSMutableArray alloc] init];
		
		for (Person* person in self.people)
		{
			if ([self personIsHot:person])
			{
				[whatsHotCache addObject:person];
			}
		}
	}
	
	return whatsHotCache;
}

#pragma mark Protected Methods

- (void) releaseCaches
{
	channelsCache = whatsHotCache = nil;
}

#pragma mark Protected Methods

- (Person*) objectInPersonsAtIndex:(NSUInteger)i
{
	return [persons objectAtIndex:i];
}

- (void) insertObject:(id)person inPersonsAtIndex:(NSUInteger)i
{
	[persons insertObject:person atIndex:i];
	[self releaseCaches];
}

- (void) removeObjectFromPersonsAtIndex:(NSUInteger)i
{
	[persons removeObjectAtIndex:i];
	[self releaseCaches];
}

- (void) createPeopleObjectsForDevelopment
{
	// Add some people for rapid prototyping...
	
	Person* person1 = [[Person alloc] initWithName:@"Person Name 1"];
	Person* person2 = [[Person alloc] initWithName:@"Person Name 2"];
	Person* person3 = [[Person alloc] initWithName:@"Person Name 3"];
	Person* person4 = [[Person alloc] initWithName:@"Person Name 4"];
	Person* person5 = [[Person alloc] initWithName:@"Person Name 5"];
	
	person5.isHot = YES;
	
	// $$$$$ hmm... a person only has one userID on Twitter. But a person object might have userIDs
	// on multiple services, hence we manage an array of user IDs here. Note: client should NOT
	// be able to manipulate the userIDs, but we're allowing it for now...
	
	[person1.userIDs addObject:@"userID1"];
	[person2.userIDs addObject:@"userID2"];
	[person3.userIDs addObject:@"userID3"];
	[person4.userIDs addObject:@"userID4"];
	[person5.userIDs addObject:@"userID5"];
	
	persons = [NSMutableArray arrayWithObjects:person1, person2, person3, person4, person5, nil];
}

+ (People*) sharedInstance
{
	static People* people = nil;
	
	if (people) return people;
	
	@synchronized (self)
	{
		if (!people)
		{
			people = [[People alloc] init];
		}
	}
	
	return people;
}

#pragma mark Object Life Cycle

- (id)init 
{
    self = [super init];
    if (self)
	{
        persons = [[NSMutableArray alloc] init];
		
		[self createPeopleObjectsForDevelopment]; // $$$$$ For development purposes only!
		
    }
    return self;
}

@end
