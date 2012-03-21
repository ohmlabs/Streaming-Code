/*
 
 MusicLibrary.m
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import "MusicLibrary.h"

#import "OhmTargetConditionals.h"
#import "SimulatorMusicLibrary.h"
#import "DeviceMusicLibrary.h"

// This function returns a music library implementation.

MusicLibrary* musicLibrary(void)
{
#if !OHM_TARGET_SIMULATE
	return [DeviceMusicLibrary sharedInstance];
#else
	return [SimulatorMusicLibrary sharedInstance];
#endif
}
