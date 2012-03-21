//
//  PostStream.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "PostStream.h"

#import "Post.h"
#import "Person.h"

@implementation PostStream

#pragma mark Public Methods

+ (PostStream*) sharedInstance
{
	static PostStream* postStream = nil;
	
	if (postStream) return postStream;
	
	@synchronized (self)
	{
		if (!postStream)
		{
			postStream = [[PostStream alloc] init];
		}
	}
	
	return postStream;
}

- (NSArray*) allPosts // $$$$$ implement
{
	const char* const YOU_TUBE		= "http://youtube.com";
	const char* const SOUNDCLOUD	= "http://soundcloud.com";
	const char* const OHM_CHANNEL	= "http://ohm.com/OhmChannel";
	
	struct DevelopmentPostInfo
	{
		const char* const userID;
		const char* const content;
	};
	
	struct DevelopmentPostInfo info[] = 
	{
		{ "userID1", YOU_TUBE},
		
		{ "userID2", YOU_TUBE},
		{ "userID2", SOUNDCLOUD},
		
		{ "userID3", YOU_TUBE},
		{ "userID3", SOUNDCLOUD},
		{ "userID3", YOU_TUBE},
		{ "userID3", SOUNDCLOUD},
		{ "userID3", YOU_TUBE},
		{ "userID3", SOUNDCLOUD},
		{ "userID3", YOU_TUBE},
		{ "userID3", SOUNDCLOUD},
		{ "userID3", YOU_TUBE},
		{ "userID3", SOUNDCLOUD},
		{ "userID3", OHM_CHANNEL}, // ISSUE: we show posts in order, so the user might have to scroll to a channel?

		{ "userID4", YOU_TUBE},
		{ "userID4", SOUNDCLOUD},
		{ "userID4", OHM_CHANNEL},
		
	};
		
	NSMutableArray* posts = [NSMutableArray array];

	const NSUInteger COUNT = sizeof(info) / sizeof(struct DevelopmentPostInfo);
	
	for (NSUInteger i = 0; i < COUNT; i++)
	{
		Post* post		= [Post post];
		post.userID		= [NSString stringWithUTF8String:info[i].userID];
		post.content	= [NSString stringWithUTF8String:info[i].content];
		
		[posts addObject:post];
		
	}
			
	return posts;
	
}

- (NSArray*) postsForPerson:(Person*)person
{
	NSMutableArray* posts = [NSMutableArray array];
	
	for (Post* post in [self allPosts])
	{
		if ([person hasUserID:post.userID])
		{
			[posts addObject:post];
		}
		
	}
	
	return posts;
}

@end
