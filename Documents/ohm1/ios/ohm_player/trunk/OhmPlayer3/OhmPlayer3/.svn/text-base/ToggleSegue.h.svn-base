//
//  ToggleSegue.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

// A custom story board segue that replaces the top UIViewController on a
// UINavigationController stack by popping and pushing a new view controller.

// To the user it looks like the visible view controller is merely displaying
// an alternative representation. The back button still works.
// Underneath the covers, however, a completely new view controller implementing
// is now visible.

// Why do this? Because we don't want to merge the responsibilities of two view
// controllers into a single 'multi-controller'.

// Note: a source view controller may have to pass delegates and/or state
// to the destination controller in its prepareForSegue: method.

@interface ToggleSegue : UIStoryboardSegue

@end
