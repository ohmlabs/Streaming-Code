/*
 
 MusicLibrarySong.h
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import <Foundation/Foundation.h>


#pragma mark MusicLibrarySong

@protocol MusicLibrarySong

@property (readonly)	NSString* name;
@property (readonly)	NSString* artist;
@property (readonly)	NSString* album;

// Uniquely identifies a song so we can check if this song
// is already in a queue.
@property (readonly)	NSString* identifier;

@end

typedef NSObject<MusicLibrarySong> MusicLibrarySong;
