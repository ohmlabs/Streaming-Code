//
//  ViewController.m
//  Gallery
//
//  Created by Reg on 8/13/11.
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "ViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation ViewController

@synthesize artistGallery;
@synthesize albumGallery;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Protected Methods

- (UIView*) artistsCellForArtists:(NSString*)anArtist
{
	static NSString*		ARTIST_CELL_FONTNAME		= @"Helvetica";
	static const CGFloat	ARTIST_CELL_FONTSIZE		= 30.0F;
	static const CGFloat	ARTIST_CELL_FONTSIZE_MIN	= 10.0F;
	
	NSParameterAssert([anArtist length]);
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
	
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
	[label sizeToFit];
	
	return label;
}

- (UIView*) genericCell:(NSString*)labelText
{
	static NSString*		CELL_FONTNAME		= @"Helvetica";
	static const CGFloat	CELL_FONTSIZE		= 30.0F;
	static const CGFloat	CELL_FONTSIZE_MIN	= 10.0F;
	
	NSParameterAssert([labelText length]);
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
	
	UIFont* font				= [UIFont fontWithName:CELL_FONTNAME size:CELL_FONTSIZE];
	UIColor* textColor			= [UIColor whiteColor];
	UIColor* backgroundColor	= [UIColor blueColor];
	
	label.text					= labelText;
	label.font					= font;
	label.textColor				= textColor;
	label.backgroundColor		= backgroundColor;
	label.textAlignment			= UITextAlignmentCenter;
	label.lineBreakMode			= UILineBreakModeTailTruncation;
	label.minimumFontSize		= CELL_FONTSIZE_MIN;
	
//	[label.layer setBorderColor:[UIColor blackColor].CGColor];
//	[label.layer setBorderWidth:1.0F];
	
	label.adjustsFontSizeToFitWidth = YES;
	[label sizeToFit];
	
	return label;
}

#pragma mark - Gallery Datasource

- (NSUInteger) numberOfColumnsInGallery:(GalleryView*)gallery
{
	if (gallery == albumGallery)
	{
		return 3;
	}
	else
	{
		return 30;
	}
}

- (id) gallery:(GalleryView*)gallery cellForColumnAtIndex:(NSUInteger)index
{		
	if (gallery == albumGallery)
	{
		return [self genericCell:[NSString stringWithFormat:@"Album %ld", (long)index]];
	}
	else
	{
		return [self artistsCellForArtists:[NSString stringWithFormat:@"Artist %ld", (long)index]];
	}
}

#pragma mark - Gallery Delegate

- (void) gallery:(GalleryView*)gallery didSelectColumnAtIndex:(NSUInteger)index
{
	if (gallery == albumGallery)
	{
		NSLog(@"%@ %@ : selected album at index %ld", [self class], NSStringFromSelector(_cmd), (long)index);
	}
	else
	{
		NSLog(@"%@ %@ : selected artist at index %ld", [self class], NSStringFromSelector(_cmd), (long)index);
	}
}

- (BOOL) shouldEnablePagingForGallery:(GalleryView*)gallery
{
	if (gallery == albumGallery)
	{
		return NO;
	}
	else
	{
		return YES;
	}
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
	[self setArtistGallery:nil];
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
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

@end
