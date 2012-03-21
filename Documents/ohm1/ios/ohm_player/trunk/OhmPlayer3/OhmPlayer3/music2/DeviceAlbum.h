//
//  DeviceAlbum.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MediaPlayer/MediaPlayer.h>

#import "Album.h"

// This class represents an on-device album.

@interface DeviceAlbum : Album {
	
	UIImage* cachedImage;
}

@property (nonatomic, strong, readonly) MPMediaItemCollection* mediaItemCollection;

- (id) initWithMediaItemCollection:(id)mediaItemCollection;

@end
