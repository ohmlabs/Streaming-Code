//
//  GalleryListViewController.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlbumsTableViewDataSource;
@class ArtistsTableViewDataSource;
@class SongsTableViewDataSource;

@interface GalleryListViewController : UIViewController<UITabBarDelegate, UITableViewDataSource>
{
	//NSObject<UITableViewDataSource, UITableViewDelegate>* selectedTableViewDataSource;

	AlbumsTableViewDataSource* albumsTableViewDataSource;
	ArtistsTableViewDataSource* artistsTableViewDataSource;
	SongsTableViewDataSource* songsTableViewDataSource;
}

@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
