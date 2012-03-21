//
//  OhmTargetConditionals.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

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
