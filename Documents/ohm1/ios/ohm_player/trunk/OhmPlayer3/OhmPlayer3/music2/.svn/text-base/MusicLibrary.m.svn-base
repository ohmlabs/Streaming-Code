//
//  MusicLibrary.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "MusicLibrary.h"

#import "OhmTargetConditionals.h"
#import "SimulatorMusicLibrary.h"
#import "DeviceMusicLibrary.h"

NSString* const MusicLibraryImageCacheDidChangeNotification = @"MusicLibraryImageCacheDidChangeNotification";

// This function returns a music library implementation.

MusicLibrary* musicLibrary(void)
{
#if !OHM_TARGET_SIMULATE
	return [DeviceMusicLibrary sharedInstance];
#else
	return [SimulatorMusicLibrary sharedInstance];
#endif
}
