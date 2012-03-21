//
//  Person.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

// Represents a Person object.

@interface Person : NSObject

@property (nonatomic, copy)		NSString*	name;				// The name to display
@property (nonatomic, copy)		NSString*	avatarImageName;	// The name of avatar image data.
@property (nonatomic, assign)	NSUInteger	unseenPostCount;	// The number of unseen content posts.
@property (nonatomic, assign)	NSUInteger	followerCount;		// The number of followers.
@property (nonatomic, assign)	NSUInteger	reputation;			// The value of a persons reputation.
@property (nonatomic, readonly)	BOOL		hasLiveChannel;		// True if this person has an active live channel.
@property (nonatomic, assign)	BOOL		isHot;				// True if this person is designated as hot.
@property (nonatomic, retain)	NSMutableArray* userIDs;		// An array of user IDs (across all possible services) associated with this person.

-(id)initWithName:(NSString*)name; // Designated initializer.

- (BOOL) hasUserID:(NSString*)userID;

@end
