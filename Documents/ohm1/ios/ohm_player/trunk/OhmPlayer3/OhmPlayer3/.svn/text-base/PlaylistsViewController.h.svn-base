//
//  PlaylistsViewController.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GalleryView.h"

@class Playlist;

@interface PlaylistsViewController : UIViewController<GalleryViewDelegate, GalleryViewDataSource, UITableViewDataSource, UITableViewDelegate>
{
	Playlist* selectedPlaylist;
	NSArray* compositePlaylists; // An array of playlist objects.
}

@property (strong, nonatomic) IBOutlet GalleryView* wire;
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIView* playlistHeaderView;
@property (strong, nonatomic) IBOutlet UIView* ohmPlaylistHeaderView;

- (IBAction) editPlaylist:(id)sender;
- (IBAction) copyPlaylist:(id)sender;
- (IBAction) deletePlaylist:(id)sender;
- (IBAction) clearPlaylist:(id)sender;
- (IBAction) shufflePlaylist:(id)sender;

@end
