//
//  PersonViewController.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "PersonViewController.h"

#import "Person.h"
#import "WireViewProvider.h"

@interface PersonViewController (ForwardDeclaration)

- (void) selectFirstItemInWire;

@end

@implementation PersonViewController

#pragma mark Properties

@synthesize person;
@synthesize wire;

#pragma mark Protected Accessors

- (WireViewProvider*) wireViewProvider
{
	if (!wireViewProvider)
	{
		wireViewProvider = [[WireViewProvider alloc] initWithPerson:person];
	}
	
	return wireViewProvider;
}

#pragma mark UIViewController Methods

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self.wire flashScrollIndicators];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Select the first item in the wire, if any...
	
	[self selectFirstItemInWire];
	
	// Set the title of this view controller to the name of the person being displayed.
	
	self.title = self.person.name;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Protected Methods

- (CGFloat) heightOfWire
{
	return wire.frame.size.height;
}

- (void) setSizeForWireCell:(UIView*)cell
{
	const CGFloat Side = [self heightOfWire];
	
	cell.frame = CGRectMake(0.0F, 0.0F, Side, Side);
}

- (void) setSizeForWireView:(UIView*)view
{
	const CGFloat height	= self.view.frame.size.height - [self heightOfWire];
	const CGFloat width		= self.view.frame.size.width;
	
	view.frame = CGRectMake(0, 0, width, height);
}

- (void) setWireView:(UIView*)newView
{
	NSParameterAssert(newView);
	
	// Note: we don't want the wire view's tag value to collide with
	// the a wire cell's tag value, so we choose a large value that a
	// cell should never have.
	
	static const NSInteger WIRE_VIEW_TAG = NSIntegerMax;
	
	newView.tag = WIRE_VIEW_TAG;

	UIView* existingView = [self.view viewWithTag:WIRE_VIEW_TAG];
	
	if (newView && existingView)
	{
		// ISSUE: the entire parent view is transitioned... Not what we want?
		
		const NSTimeInterval TRANSITION_SECS = 0.15F;
		
		[UIView transitionFromView:existingView toView:newView duration:TRANSITION_SECS options:(UIViewAnimationOptionTransitionCrossDissolve) completion:NULL];
	}
	else if (newView)
	{		
		[self.view addSubview:newView];
	}
}

- (void) selectFirstItemInWire
{
	if ([[self wireViewProvider] numberOfColumnsInWire])
	{
		[self gallery:self.wire didSelectColumnAtIndex:0];
	}
}

#pragma mark GalleryViewDelegate Methods

- (void) gallery:(GalleryView*)gallery didSelectColumnAtIndex:(NSUInteger)index
{
	UIView* view =  [[self wireViewProvider] wireViewForColumnAtIndex:index];

	if (view)
	{
		[self setSizeForWireView:view];
		
		[self setWireView:view];
	}

}

- (BOOL) shouldEnablePagingForGallery:(GalleryView*)gallery
{
	return NO;
}

#pragma mark GalleryViewDataSource Methods

- (NSUInteger) numberOfColumnsInGallery:(GalleryView*)gallery
{
	return [[self wireViewProvider] numberOfColumnsInWire];
}

- (id) gallery:(GalleryView*)gallery cellForColumnAtIndex:(NSUInteger)index
{
	UIView* cell = [[self wireViewProvider] wireCellForColumnAtIndex:index];

	if (cell) [self setSizeForWireCell:cell];
	
	return cell;
}

- (IBAction)rateUp:(id)sender
{
	NSLog(@"Rate up %@", person.name);
}

@end
