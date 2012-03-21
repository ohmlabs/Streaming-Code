/*
 
 VaultViewController.h
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */


#import <UIKit/UIKit.h>

@class VaultArtistIndexView;
@class VaultArtistsView;
@class VaultAlbumsView;
@class VaultSongsTableViewController;

@interface VaultViewController : UIViewController<UIScrollViewDelegate> {
    
@private
	
	VaultArtistIndexView*			artistsIndexView;
	VaultArtistsView*				artistsView;
	VaultAlbumsView*				albumsView;
	VaultSongsTableViewController*	songsTableViewController;
	
	UITableView*					songsTableView;
	UITableViewCell*				albumTitleCell;
}

@property (retain) IBOutlet VaultArtistIndexView*			artistsIndexView;
@property (retain) IBOutlet VaultArtistsView*				artistsView;
@property (retain) IBOutlet VaultAlbumsView*				albumsView;
@property (retain) IBOutlet UITableView*					songsTableView;
@property (retain) IBOutlet UITableViewCell*				albumTitleCell;


// Called by the albums view when the user taps an album.
- (void) updateAlbumSongsView;

@end
