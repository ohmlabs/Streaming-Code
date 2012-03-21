//
//  OhmViewController.h
//  OhmPlayer4
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlaylistThemesViewController.h"
#import "NowPlayingViewController.h"

@interface OhmViewController : NowPlayingViewController<PlaylistThemesViewControllerDelegate>

- (void)done:(PlaylistThemesViewController*)PlaylistThemesViewController;

@end
