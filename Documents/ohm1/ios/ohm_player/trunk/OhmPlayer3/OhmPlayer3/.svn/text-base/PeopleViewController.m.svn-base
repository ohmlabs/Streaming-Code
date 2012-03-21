//
//  PeopleViewController.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "PeopleViewController.h"

#import "People.h"
#import "Person.h"
#import "PersonViewController.h"

@implementation PeopleViewController

#pragma mark - Properties

@synthesize segmentedControl;
@synthesize tableView;

#pragma mark - Protected Methods

- (NSArray*) peopleForCurrentSegmentFilter
{
	const NSInteger selectedIndex = [segmentedControl selectedSegmentIndex];
	
	enum {TAG_PEOPLE = 0, TAG_CHANNELS = 1, TAG_WHATS_HOT = 2};
	
	NSArray* people = nil;
	
	switch (selectedIndex)
	{			
		case TAG_CHANNELS:
		{
			people = [[People sharedInstance] channels];
			break;
		}
			
		case TAG_WHATS_HOT:
		{
			people = [[People sharedInstance] whatsHot];
			break;
		}
			
		case TAG_PEOPLE:	
		default:
		{
			people = [[People sharedInstance] people];
			break;
		}
	}
	
	return people;
}

- (NSUInteger) countOfPeopleForCurrentSegmentFilter
{
	return [[self peopleForCurrentSegmentFilter] count];
}

- (void) configureTableViewCell:(UITableViewCell*)cell withPerson:(Person*)person
{
	cell.textLabel.text = [person name];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (NSInteger)[self countOfPeopleForCurrentSegmentFilter];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
	[self configureTableViewCell:cell withPerson:[[self peopleForCurrentSegmentFilter] objectAtIndex:indexPath.row]];
	
    return cell;
}

#pragma mark - Actions

- (IBAction)changedListFilter:(id)sender
{
	[tableView reloadData];
}

#pragma mark - UIViewController Methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	static NSString* const PERSON_SEGUE = @"person";
	
	if ([[segue identifier] isEqualToString:PERSON_SEGUE])
	{
		PersonViewController* vc = [segue destinationViewController];
		
		NSIndexPath* indexPath = [tableView indexPathForSelectedRow];
		
		if (indexPath)
		{
			vc.person = [[self peopleForCurrentSegmentFilter] objectAtIndex:indexPath.row];
		}
	}
	
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

@end
