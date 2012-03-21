//
//  PlaylistThemesViewController.h
//  OhmPlayer4
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Delegate

@class PlaylistThemesViewController;

@protocol PlaylistThemesViewControllerDelegate <NSObject>

- (void)done:(PlaylistThemesViewController*)PlaylistThemesViewController;

@end

#pragma mark - Class

@interface PlaylistThemesViewController : UIViewController

- (IBAction)done:(id)sender;

@property (nonatomic, assign) IBOutlet id<PlaylistThemesViewControllerDelegate> delegate;

@end
