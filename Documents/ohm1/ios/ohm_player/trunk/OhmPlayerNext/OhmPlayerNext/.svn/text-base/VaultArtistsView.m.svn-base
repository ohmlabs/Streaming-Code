/*
 
 VaultArtistsView.m
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import "VaultArtistsView.h"

@implementation VaultArtistsView

#pragma mark Protected Methods

- (void) removeAllSubviewsFromView:(UIView*)view
{
	for (UIView* v in view.subviews)
	{
		[v removeFromSuperview];
	}
	
}

- (UIView*) artistsCellForArtists:(NSString*)anArtist
{
	static NSString*		ARTIST_CELL_FONTNAME		= @"Helvetica";
	static const CGFloat	ARTIST_CELL_FONTSIZE		= 30.0F;
	static const CGFloat	ARTIST_CELL_FONTSIZE_MIN	= 10.0F;

	NSParameterAssert([anArtist length]);
	
	UILabel* label = [[[UILabel alloc] initWithFrame:CGRectNull] autorelease];
	
	UIFont* font				= [UIFont fontWithName:ARTIST_CELL_FONTNAME size:ARTIST_CELL_FONTSIZE];
	UIColor* textColor			= [UIColor whiteColor];
	UIColor* backgroundColor	= [UIColor clearColor];

	label.text					= anArtist;
	label.font					= font;
	label.textColor				= textColor;
	label.backgroundColor		= backgroundColor;
	label.textAlignment			= UITextAlignmentCenter;
	label.lineBreakMode			= UILineBreakModeTailTruncation;
	label.minimumFontSize		= ARTIST_CELL_FONTSIZE_MIN;
	
	label.adjustsFontSizeToFitWidth = YES;

	return label;
}

- (CGRect) rectForPage:(NSUInteger)page
{
	UIScrollView* scrollView = self;
	
	return CGRectMake((page * scrollView.bounds.size.width),
					  scrollView.bounds.origin.y,
					  scrollView.bounds.size.width,
					  scrollView.bounds.size.height);
}

- (void) scrollToPage:(NSUInteger)page animated:(BOOL)animated
{
	[self scrollRectToVisible:[self rectForPage:page] animated:animated];
}

- (NSUInteger) selectedPage
{
	return (NSUInteger)(self.bounds.origin.x / self.bounds.size.width);
}

- (void) selectPage:(NSUInteger)page
{
	[self scrollToPage:page animated:NO];
}

- (NSUInteger) pageForArtist:(NSString*)anArtist
{
	const NSUInteger artistPage = [artists indexOfObject:anArtist];
	return (NSNotFound == artistPage) ? [self selectedPage] : artistPage;
}

#pragma mark Public Properties

- (NSString*) artist
{		
	return [artists objectAtIndex:[self selectedPage]];
}

- (void) setArtist:(NSString *)anArtist
{
	[self selectPage:[self pageForArtist:anArtist]];
}

- (NSArray*) artists
{		
	return artists;
}

- (void) setArtists:(NSArray*)artistsLists
{
	if (artists != artistsLists)
	{
		[artists release];
		artists = [artistsLists retain];
		
		[self updateArtistsCells];
	}
}

#pragma mark Public Methods

- (void) updateArtistsCells
{	
	// $$$$$ This is memory and performance inefficient. We SHOULD NOT create a cell for every artist and add it as a subview.
	// I'm only doing this for speed. We can optimize it later. It will almost defintely need to be optimized for a device
	// but we can get away with it for now in the simulator... Ideally, we would use no more than 3 cells at a time -
	// next, current, and previous, and reuse reclaimed cells to avoid unecessary memory allocations...
	
	NSLog(@"%@ %@ called", [self class], NSStringFromSelector(_cmd));
	
	UIScrollView* artistsView = self;
		
	[self removeAllSubviewsFromView:artistsView];
	
	NSUInteger i = 0;
	
	for (NSString* anArtist in artists)
	{	
		i++;
		
		UIView* cell = [self artistsCellForArtists:anArtist];
		
		if (!cell)
		{
			NSAssert1(NO, @"Could not get cell for artist %@", anArtist);
			continue;
		}
		
		[artistsView addSubview:cell];
		
		cell.frame = CGRectOffset(artistsView.bounds, artistsView.bounds.size.width * (i - 1), 0);
								
	}
	
	[artistsView setContentSize:CGSizeMake([artists count] * artistsView.bounds.size.width, artistsView.bounds.size.height)];

}

#pragma mark Object Life Cycle

- (void)dealloc
{	
    [super dealloc];
}

@end
