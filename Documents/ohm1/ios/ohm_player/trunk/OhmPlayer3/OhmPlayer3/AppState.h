//
//  AppState.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

// Theory of operation: view controller subclasses can read/store their state in the appState dictionary
// from their viewWillAppear/viewWillDisappear methods so they can remember where they are.

NSMutableDictionary* appState(void);
