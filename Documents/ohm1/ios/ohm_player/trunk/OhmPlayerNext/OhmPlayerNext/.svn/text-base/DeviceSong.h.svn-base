/*
 
 DeviceSong.h
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import <Foundation/Foundation.h>


/*
 
 This class represents a song (i.e. audio-only media item) in the user's music library.
 
 */

#import "MusicLibrary.h"
#import "MusicLibrarySong.h"

@class MPMediaItem;

@interface DeviceSong : NSObject<MusicLibrarySong> {
	
	NSString* name;
	NSString* artist;
	NSString* album;
	
	MPMediaItem* mediaItem;
	
	NSString* identifier;
}

@property (readonly)	NSString* name;
@property (readonly)	NSString* artist;
@property (readonly)	NSString* album;

@property (readonly)	NSString* identifier;
@property (readonly)	MPMediaItem* mediaItem;

- (id) initWithMediaItem:(MPMediaItem*)mediaItem; // Designated initializer.

@end
