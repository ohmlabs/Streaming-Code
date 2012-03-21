//
//  Person.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "Person.h"

#import "Post.h"
#import "PostStream.h"

@implementation Person

#pragma mark Properties

@synthesize name;
@synthesize avatarImageName;
@synthesize unseenPostCount;
@synthesize followerCount;
@synthesize reputation;
@synthesize isHot;
@synthesize userIDs;

- (BOOL) hasLiveChannel
{
	for (Post* post in [[PostStream sharedInstance] postsForPerson:self])
	{
		if ([post hasLiveChannel])
		{
			return YES;
		}
	}

	return NO;
}

#pragma mark Public Methods

- (BOOL) hasUserID:(NSString*)userID
{
	NSParameterAssert(userID);
	
	return (userID) ? [userIDs containsObject:userID] : NO;
}

#pragma mark Object Life Cycle

-(id)initWithName:(NSString*)aName // Designated initializer.
{
	NSParameterAssert(aName);
	
	if ((self = [super init]))
	{
		self.name = aName;
		self.userIDs = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (id) init
{
	return [self initWithName:@""];
}

@end
