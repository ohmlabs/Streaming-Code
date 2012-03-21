//
//  Post.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "Post.h"

static NSString* const POST_TYPE_OHM_CHANNEL	= @"tw_OhmChannel";

@implementation Post

#pragma mark Properties

@synthesize userID;
@synthesize content;

#pragma mark Protected Methods

- (NSString*) postType:(Post*)post
{
	// ISSUE: $$$$$ We should use NSDataDetectors to extract URLs and their hosts...
	// For now, I'm just going to grok development data.
	
	// Also, this method should be implemented by service specific subclasses, but since
	// we only support twitter for 1.0, I'm assuming twitter specfic content in this
	// would-be base class...

	static NSString* const POST_TYPE_SOUNDCLOUD		= @"tw_SoundCloud";
	static NSString* const POST_TYPE_YOUTUBE		= @"tw_youTube";
	
	if ([content rangeOfString:@"soundcloud" options:NSCaseInsensitiveSearch].location != NSNotFound)
	{
		return POST_TYPE_SOUNDCLOUD;
	}
	
	if ([content rangeOfString:@"ohmchannel" options:NSCaseInsensitiveSearch].location != NSNotFound)
	{
		return POST_TYPE_OHM_CHANNEL;
	}
	
	if ([content rangeOfString:@"youtube" options:NSCaseInsensitiveSearch].location != NSNotFound)
	{
		return POST_TYPE_YOUTUBE;
	}
	
	NSAssert(NO, @"Unknown type in content : %@ ; %@", (id)post, content); 
	
	return nil;
}

#pragma mark Public Methods

+ (Post*) post
{
	return [[Post alloc] init];
}

- (NSString*) type
{
	if (!type)
	{
		type = [self postType:self];
	}
	
	return type;
}

- (BOOL) hasLiveChannel
{
	return [[self type] isEqualToString:POST_TYPE_OHM_CHANNEL];
}

@end
