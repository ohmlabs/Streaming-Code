//
//  DevicePlaylist.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "Playlist.h"

#import <MediaPlayer/MediaPlayer.h>

@interface DevicePlaylist : Playlist

@property (nonatomic, strong, readonly) MPMediaPlaylist* mediaPlaylist;

- (id) initWithMediaPlaylist:(id)mediaPlaylist;

@end
