/*
 
 MusicLibrary.h
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import <Foundation/Foundation.h>

/*
 
 This protocol abstracts a music library implementation.
 
 */

#pragma mark MusicLibrary

@protocol MusicLibrary 

// Returns strings of artist names.
- (NSArray*) artists;

// Returns string of album names.
- (NSArray*) albumsForArtist:(NSString*)anArtist;

// Returns MusicLibrarySong objects.
- (NSArray*) songsForArtist:(NSString*)anArtist album:(NSString*)anAlbum;

// Returns image data for a given artist+album.
- (UIImage*) imageForArtist:(NSString*)anArtist album:(NSString*)anAlbum withSize:(CGSize)aSize;

@end

typedef NSObject<MusicLibrary> MusicLibrary;

extern NSString* const MusicLibraryImageCacheUpdatedNotification;

#pragma mark Music Library Functions

// This function returns a music library implementation appropriate for use in the iOS Simulator
// or on an iOS device depending on the compilation target.

MusicLibrary* musicLibrary(void);
