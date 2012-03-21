/*
 
 VaultSongsTableViewController.h
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import <UIKit/UIKit.h>


@interface VaultSongsTableViewController : UITableViewController {
    
	NSString*			artist;
	NSString*			album;
	UITableViewCell*	prototypeSongTableViewCell;
	
	NSArray*			cachedSongs; // PERFORMANCE: The music library object doesn't cache its results, so clients should.
}

@property (retain) NSString*					artist;
@property (retain) NSString*					album; // If nil, all songs for an artist are displayed.
@property (assign) IBOutlet UITableViewCell*	prototypeSongTableViewCell;

- (id) initWithTableView:(UITableView*)tableView; // Designated initializer

@end
