//
//  QueueViewController.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "QueueViewController.h"

#import "MusicLibrary.h"
#import "MusicPlayer.h"
#import "MutablePlaylist.h"
#import "OhmPlaylistManager.h"
#import "OhmAppearance.h"
#import "OhmBarButtonItems.h"
#import "AppState.h"

static NSString* const QUEUE_SONG_CELL_REUSE_ID		= @"QueueCell";
static NSString* const NAV_BAR_BACKGROUND_IMAGE		= @"nav_bar_banner";
static NSString* const NAV_BAR_RIGHT_BUTTON_IMAGE	= @"music_btn_up";
static NSString* const NAV_BAR_LEFT_BUTTON_IMAGE	= @"back_btn_up";
static NSString* const SEGUE_FROM_QUEUE_TO_MUSIC_SCREEN_ID	= @"QueueToMusicSegue";

@implementation QueueViewController

#pragma mark Protected Methods

- (MusicLibrary*) musicLibrary
{
	return musicLibrary();
}

- (MusicPlayer*) musicPlayer
{
	return musicPlayer();
}

- (NSArray*) songs
{
	return [[OhmPlaylistManager queue] songs];
}

- (UITableViewCell*) tableViewCell
{
	return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:QUEUE_SONG_CELL_REUSE_ID];
}

- (void) configureCell:(UITableViewCell*)cell forSong:(Song*)song
{	
	if ([[self musicPlayer] isPlayingSong:song])
	{
		cell.textLabel.textColor = [UIColor lightGrayColor];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	else
	{
		cell.textLabel.textColor = [UIColor darkTextColor];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	cell.textLabel.text = song.title;
	
	const CGSize imageSize = CGSizeMake(cell.frame.size.height, cell.frame.size.height);
	
	cell.imageView.image = [song imageWithSize:imageSize];
	
	NSString* albumAndArtist = nil;
	
	if (song.artistName && song.albumName)
	{
		albumAndArtist = [NSString stringWithFormat:@"%@ - %@", song.albumName, song.artistName];
	}
	else if (song.artistName)
	{
		albumAndArtist = [NSString stringWithFormat:@"%@", song.artistName];
	}
	else if (song.albumName)
	{
		albumAndArtist = [NSString stringWithFormat:@"%@", song.albumName];
	}
	
	cell.detailTextLabel.text = albumAndArtist;
	
}


- (UIColor*) tableViewBackgroundColor
{
	return [OhmAppearance defaultTableViewBackgroundColor];
}

- (Song*) songForIndexPath:(NSIndexPath*)indexPath
{	
	const NSInteger row = [indexPath row];
	
	NSArray* songs = [self songs];
	
	return (row >=0 && [songs count]) ? [songs objectAtIndex:row] : nil;
}

- (void) playSongInTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath
{	
	MusicLibrarySong* song = [self songForIndexPath:indexPath];
	
	if (song)
	{
		[[self musicPlayer] playSong:song inCollection:[OhmPlaylistManager queue]];
		
		// Note: we must show the now playing indicator at the new index path and remove
		// it from any cells on-screen that might correspond to the previously playing index path.
		
		// Ideally, if we used the previous index path, we would only have to reload the cell
		// at the current index path and the previous index path's cell if the cell is on-screen.
		// Note: however, reloading the entire table doesn't appear to result in noticeable performance
		// penalties for the users, so we do the easy thing.
		
		[tableView reloadData];
	}
}

- (void) segueToNowPlayingScreen
{
#if OHM_TARGET_4
	[[self navigationController] popViewControllerAnimated:YES];
#else
	[self performSegueWithIdentifier:SEGUE_FROM_GALLERY_TO_NOW_PLAYING_ID sender:self];
#endif
}

#pragma mark Protected Methods - NavigationBar Setup

- (void) setUpNavigationBarAppearance
{
	UIImage* image = [UIImage imageNamed:NAV_BAR_BACKGROUND_IMAGE];
	
	if (image)
	{
		UINavigationBar* navBar = self.navigationController.navigationBar;
		
		[navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

		[navBar setTitleTextAttributes:[OhmAppearance defaultNavBarTextAttributes]];
	}
}

- (void) setUpRightNavigationBarButton
{	
	id target						= self;
	const SEL action				= @selector(segueToMusicScreen:);
	NSString* const	IMAGE_NAME		= NAV_BAR_RIGHT_BUTTON_IMAGE;
	
	UIBarButtonItem* barButtonItem = [OhmBarButtonItems barButtonItemWithImageNamed:IMAGE_NAME target:target action:action];
	
	if (barButtonItem) 
	{
		[self.navigationItem setRightBarButtonItem:barButtonItem];
	}
}

- (void) setUpLeftNavigationBarButton
{	
	id target						= self;
	const SEL action				= @selector(back:);
	NSString* const	IMAGE_NAME		= NAV_BAR_LEFT_BUTTON_IMAGE;
	
	UIBarButtonItem* barButtonItem = [OhmBarButtonItems barButtonItemWithImageNamed:IMAGE_NAME target:target action:action];
	
	if (barButtonItem) 
	{
		[self.navigationItem setLeftBarButtonItem:barButtonItem];
	}
}

- (void) setUpNavBar
{
	[self setUpNavigationBarAppearance];
	[self setUpRightNavigationBarButton];
	[self setUpLeftNavigationBarButton];
}

#pragma mark UIViewController Methods

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.tableView.backgroundColor = [self tableViewBackgroundColor];
	
	[self setUpNavBar];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (NSInteger)[[self songs] count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:QUEUE_SONG_CELL_REUSE_ID];
	if (!cell)
	{
		cell = [self tableViewCell];
	}
	
	// Configure the cell...
		
	MusicLibrarySong* song = [self songForIndexPath:indexPath];

	if (song)
	{
		[self configureCell:cell forSong:song];
		cell.accessoryView.tag = [indexPath row]; // IMPORTANT: Tag the accessory view so we can quickly determine its row later...
	}
	
	return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	
	[self playSongInTableView:tableView atIndexPath:indexPath];

#if OHM_TARGET_4
	// We have to manually segue to the Ohm/Now Playing screen. Otherwise, the segue is already setup in the storyboard.
	
	[self segueToNowPlayingScreen];
#endif
}

#pragma mark Actions

- (IBAction)segueToMusicScreen:(id)sender
{
	[self performSegueWithIdentifier:SEGUE_FROM_QUEUE_TO_MUSIC_SCREEN_ID sender:self];
}

- (IBAction)back:(id)sender
{
	[[self navigationController] popViewControllerAnimated:YES];
}

@end
