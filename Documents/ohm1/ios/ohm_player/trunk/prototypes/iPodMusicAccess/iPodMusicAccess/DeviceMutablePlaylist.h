//
//  DeviceMutablePlaylist.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "MutablePlaylist.h"

#import <MediaPlayer/MediaPlayer.h>

// This class represents an on-device mutable playlist.

@interface DeviceMutablePlaylist : MutablePlaylist
{
@private
	
	NSArray* mediaItems;
}

@end
