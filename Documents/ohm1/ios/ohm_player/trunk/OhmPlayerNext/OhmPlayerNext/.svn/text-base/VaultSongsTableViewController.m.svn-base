/*
 
 VaultSongsTableViewController.m
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import "VaultSongsTableViewController.h"

#import "MusicLibrary.h"
#import "MusicLibrarySong.h"
#import "MusicQueue.h"

static NSString* VaultSongCell = @"VaultSongCell";

@implementation VaultSongsTableViewController

#pragma mark Properties - Synthesized

@synthesize artist;
@synthesize prototypeSongTableViewCell;

#pragma mark Properties

- (void) setAlbum:(NSString*)anAlbum
{
	if (album != anAlbum)
	{
		[album release];
		album = [anAlbum retain];
		
		// Release the songsCache for the previous album, if any.
		[cachedSongs autorelease]; cachedSongs = nil;
		
		[[self tableView] reloadData];
		
		NSIndexPath* topRow = [[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:0];
		
		[[self tableView] scrollToRowAtIndexPath:topRow atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
	
}

- (NSString*) album
{
	return album;
}

#pragma mark Protected Methods

- (MusicLibrary*) musicLibrary
{
	return musicLibrary();
}

- (MusicQueue*) musicQueue
{
	return musicQueue();
}

- (UITableViewCell*) tableViewCell
{
	// Loading the tableview cell xib causes this object's prototypeSongTableViewCell
	// outlet to be assigned (and autoreleased).
	[[NSBundle mainBundle] loadNibNamed:VaultSongCell owner:self options:nil];
	
	UITableViewCell* cell = prototypeSongTableViewCell;
	
	prototypeSongTableViewCell = nil;
	
	return cell;
}

- (NSArray*) songsForArtistAndAlbum
{
	if (!cachedSongs)
	{
		cachedSongs = [[self musicLibrary] songsForArtist:self.artist album:self.album];
		[cachedSongs retain];
	}
	
	return cachedSongs;
}

- (void) configureTableViewCell:(UITableViewCell*)cell forSong:(MusicLibrarySong*)song
{
	cell.textLabel.text = [song name];
	
	// Dim the label for cells representing songs already in the user's Queue.
	
	MusicQueue* queue = [self musicQueue];
	
	if ([queue containsSong:song])
	{
		cell.textLabel.textColor = [UIColor darkGrayColor];
	}
	
}

#pragma mark Object Life Cycle

- (id) initWithTableView:(UITableView*)aTableView 
{
	NSParameterAssert(aTableView);
	
	if (!aTableView)
	{
		[self release];
		return nil;
	}
	
    self = [super initWithStyle:aTableView.style];
    if (self) {
        self.tableView = [aTableView retain];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
    }
    return self;
}

- (void)dealloc
{
	[artist release];
	[album release];
    [cachedSongs release];
	
	[super dealloc];
}

#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self songsForArtistAndAlbum] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
	{
        cell = [self tableViewCell];
    }
    
    // Configure the cell...
    	
	NSArray* songs = [self songsForArtistAndAlbum];
	
	if ([songs count])
	{
		MusicLibrarySong* song = [songs objectAtIndex:[indexPath row]];
		if (song)
		{
			[self configureTableViewCell:cell forSong:song];
		}
	}
	else
	{
		cell.textLabel.text = NSLocalizedString(@"Untitled", @"Untitled");
	}
	
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	
	MusicLibrarySong* song = [[self songsForArtistAndAlbum] objectAtIndex:[indexPath row]];
	
	[[self musicQueue] addSong:song];

	// Reload/redraw just the selected cell.
	
	NSArray* paths = [[NSArray alloc] initWithObjects:indexPath, nil];
	[tableView reloadRowsAtIndexPaths:paths withRowAnimation:NO];
	[paths release];
}

@end
