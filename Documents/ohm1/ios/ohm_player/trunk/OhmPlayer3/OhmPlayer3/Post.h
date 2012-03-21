//
//  Post.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject
{
	NSString* type;
}

@property (nonatomic, copy) NSString* userID; // ISSUE: Should this be a pointer to a Person object?
@property (nonatomic, copy) NSString* content;

@property (readonly) NSString* type;

// Returns an empty post object.
+ (Post*) post;

- (BOOL) hasLiveChannel;

@end
