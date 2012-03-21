//
//  MusicPlayer.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "MusicPlayer.h"

#import "OhmTargetConditionals.h"
#import "SimulatorMusicPlayer.h"
#import "DeviceMusicPlayer.h"

// This function returns a music player implementation.

MusicPlayer* musicPlayer(void)
{
#if !OHM_TARGET_SIMULATE
	return [DeviceMusicPlayer sharedInstance];
#else
	return [SimulatorMusicPlayer sharedInstance];
#endif
}
