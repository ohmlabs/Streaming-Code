//
//  GalleryListViewController.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongsTableViewSupport;
@class NotificationListener;
@class AlbumsTableViewDataSource;
@class ArtistsTableViewDataSource;
@class SongsTableViewDataSource;

@interface GalleryListViewController : UIViewController<UITabBarDelegate, UITableViewDataSource>
{
	NSObject<UITableViewDataSource, UITableViewDelegate>* selectedTableViewDataSource;
	
	AlbumsTableViewDataSource* albumsTableViewDataSource;
	ArtistsTableViewDataSource* artistsTableViewDataSource;
	SongsTableViewDataSource* songsTableViewDataSource;
	
	SongsTableViewSupport* songsTableViewSupport;
	NotificationListener* nowPlayingItemDidChangeNotificationListener;
	NotificationListener* imageCacheDidChangeNotificationListener;
}

@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)segueToNowPlayingScreen:(id)sender;
- (IBAction)back:(id)sender;

@end
