//
//  WireViewProvider.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "WireViewProvider.h"

#import "Person.h"
#import "PostStream.h"
#import "Post.h"
#import "OLTwitterService.h"

@implementation WireViewProvider

#pragma mark Properties

@synthesize person;

#pragma mark Protected Methods

- (NSArray*) postsForPerson
{
	return [[PostStream sharedInstance] postsForPerson:self.person];
}

- (NSArray*) allPosts
{
	return [[PostStream sharedInstance] allPosts];
}

- (NSArray*) posts
{
	return (self.person) ? [self postsForPerson] : [self allPosts];
}

- (UIView*) wireCellForTwitterPost:(Post*)post
{	
	return [[OLTwitterService sharedInstance] wireCellForPost:post];
}

- (UIView*) wireViewForTwitterPost:(Post*)post
{	
	return [[OLTwitterService sharedInstance] wireViewForPost:post];
}

#pragma mark Public Methods

- (NSUInteger) numberOfColumnsInWire
{
	return [[self posts] count];
}

- (UIView*) wireViewForColumnAtIndex:(NSUInteger)index
{
	Post* post = [[self posts] objectAtIndex:index];
	
	if (post && [OLTwitterService originatedPost:post])
	{
		return [self wireViewForTwitterPost:post];
	}
	
	return nil;
	
}

- (UIView*) wireCellForColumnAtIndex:(NSUInteger)index;
{
	Post* post = [[self posts] objectAtIndex:index];
	
	if (post && [OLTwitterService originatedPost:post])
	{
		return [self wireCellForTwitterPost:post];
	}
	
	return nil;
	
}

#pragma mark Object Life Cycle

- (id)initWithPerson:(Person *)aPerson
{
    self = [super init];
    if (self)
	{
        self.person = aPerson;
    }
	
    return self;
}

- (id) init
{
	return [self initWithPerson:nil];
}

@end
