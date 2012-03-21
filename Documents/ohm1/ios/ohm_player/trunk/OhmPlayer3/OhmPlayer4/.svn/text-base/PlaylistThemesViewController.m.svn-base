//
//  PlaylistThemesViewController.m
//  OhmPlayer4
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "PlaylistThemesViewController.h"

@implementation PlaylistThemesViewController

#pragma mark Properties

@synthesize delegate;

#pragma mark UIViewController Methods

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{	
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[self setDelegate:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Public Methods

- (IBAction)done:(id)sender
{
	NSParameterAssert(delegate);
	
	[delegate done:self];
}

@end
