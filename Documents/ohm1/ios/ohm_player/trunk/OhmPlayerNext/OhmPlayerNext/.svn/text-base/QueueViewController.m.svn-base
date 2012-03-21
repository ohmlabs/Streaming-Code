/*
 
 QueueViewController.m
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */


#import "QueueViewController.h"

#import "MusicQueue.h"
#import "MusicLibrarySong.h"

static NSString* NIB_NAME = @"QueueViewController";

@implementation QueueViewController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) init // Designated initializer.
{
	return [self initWithNibName:NIB_NAME bundle:nil];
}

- (void)dealloc
{
	[tableView release];

    [super dealloc];
}

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
    // Do any additional setup after loading the view from its nib.
	
	self.view.backgroundColor = [UIColor blackColor];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated
{
	[tableView reloadData];
}

#pragma mark Protected Methods

- (UITableViewCell*) tableViewCell
{
	return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] autorelease];
}

- (void) configureTableViewCell:(UITableViewCell*)cell forSong:(MusicLibrarySong*)song
{
	cell.textLabel.text			= song.name;
	cell.detailTextLabel.text	= song.artist;
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
	return [musicQueue() countOfSongs];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
	{
        cell = [self tableViewCell];
    }
    
    // Configure the cell...
	
	MusicQueue* queue = musicQueue();
	
	NSAssert1(queue, @"Could not get music queue", nil);
	
	if ([queue countOfSongs])
	{
		MusicLibrarySong* song = [queue objectInSongsAtIndex:[indexPath row]];
		if (song)
		{
			[self configureTableViewCell:cell forSong:song];
		}
	}
	else
	{
		cell.textLabel.text = NSLocalizedString(@"Untitled", @"Untitled");
	}
		
//	if ([indexPath row] == 1)
//	{
//		UIImage* image = [UIImage imageNamed:@"Alpha_vault_.jpg"];
//		cell.imageView.image = image;
//	}
	
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];

	MusicQueue* queue = musicQueue();

	[queue skipToItemAtIndex:[indexPath row]];
}

@end
