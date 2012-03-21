//
//  DevicePersistentPlaylist.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "PersistentPlaylist.h"

#import <MediaPlayer/MediaPlayer.h>

// This class represents an on-device persistent and mutable playlist.

// Note: by design, this device-specific class is a subclass of PersistentPlaylist
// NOT a subclass of DevicePlaylist. The reason is: DevicePlaylist's are read-only
// objects and implemented using immutable MPMediaPlaylist objects.
// Nevertheless, it's useful for this class to inherit MutablePlaylist methods to
// manage modifiable collections of songs.

@interface DevicePersistentPlaylist : PersistentPlaylist
{
@private
	
	NSArray* mediaItems;
}

@end
