//
//  SimulatorPlaylist.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "MutablePlaylist.h"

// Note: the simulator playlist class represents an immutable playlist
// (as if synched from iTunes) but it has to actually be mutable so that
// the simulator music library can create it.

@interface SimulatorPlaylist : MutablePlaylist

@end
