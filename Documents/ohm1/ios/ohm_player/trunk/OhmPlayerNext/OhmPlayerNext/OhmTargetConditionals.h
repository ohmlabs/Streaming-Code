/*
 
 OhmTargetConditionals.h
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#if !TARGET_IPHONE_SIMULATOR

// When running on a device optionaly enable the Ohm device simulation anyway...

	#if 0
		#define OHM_TARGET_SIMULATE 1
	#else
		#define OHM_TARGET_SIMULATE 0
	#endif

#else

// When running in the iOS simulator, don't try to use the device related classes. They don't work.

	#define OHM_TARGET_SIMULATE 1

#endif
