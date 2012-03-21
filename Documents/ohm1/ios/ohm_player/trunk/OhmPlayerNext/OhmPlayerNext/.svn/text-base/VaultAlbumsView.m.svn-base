/*
 
 VaultAlbumsView.m
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import "VaultAlbumsView.h"

#import "MusicLibrary.h"

#pragma mark Constants

static NSString* NIB_NAME						= @"VaultAlbumCell";

static const NSUInteger MAX_NUM_VISIBLE_ALBUMS	= 3;
static const NSInteger	VIEW_TAG_UIIMAGE_VIEW	= 1; // A UIImageView with this tag must appear in the xib.


@implementation VaultAlbumsView

#pragma Properties - Synthesized

@synthesize prototypeAlbumCell;

#pragma mark Protected Methods

- (MusicLibrary*) musicLibrary
{
	return musicLibrary();
}

- (UIView*)loadCellFromNib
{
	// Load a nib with this object as the owner. An owner outlet will get a reference
	// to the unarchived cell in the nib.
	
	[[NSBundle mainBundle] loadNibNamed:NIB_NAME owner:self options:nil];
	
	UIView* cell = self.prototypeAlbumCell; // This outlet was set by loadNibNamed:owner:options:
											// using setValue:forKey: and was not retained!
	
	prototypeAlbumCell = nil; // Stop using the outlet so we can use it again; do NOT use a synthesized property accessor
							  // or it may release the cell!
	
	return cell;
}

- (UIImageView*) imageViewForCell:(UIView*)cell
{
	UIView* imageView = [cell viewWithTag:VIEW_TAG_UIIMAGE_VIEW];
	
	NSAssert2([imageView isKindOfClass:[UIImageView class]], @"Expected class %@; got class %@", [UIImageView class], [imageView class]);
	
	return (UIImageView*)imageView;
}

- (UIView*) albumCellForAlbum:(NSString*)anAlbum
{	
	// $$$$$ PERFORMANCE: reuse a 'cell' if we can!
	
	UIView* cell = [self loadCellFromNib];
		
	cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.bounds.size.width / MAX_NUM_VISIBLE_ALBUMS, self.bounds.size.height);
    
    UIColor* backgroundColor	= [UIColor clearColor];
    cell.backgroundColor		= backgroundColor;
    
    UIImage* image = [[self musicLibrary] imageForArtist:self.artist album:anAlbum withSize:cell.frame.size];
	
	[self imageViewForCell:cell].image = image;
		
	return cell;
}

- (NSArray*) albumsForArtist:(NSString*)anArtist
{
	return [[self musicLibrary] albumsForArtist:anArtist];
}

- (void) removeAllSubviewsFromView:(UIView*)view
{
	for (UIView* v in view.subviews)
	{
		[v removeFromSuperview];
	}
	
}

- (void) horizontallyOffsetAllSubviews:(const CGFloat)points
{
	for (UIView* v in self.subviews)
	{
		v.frame = CGRectOffset(v.frame, points, 0);
	}
	
}

- (void) updateCells
{	
//	 $$$$$ This is memory and performance inefficient. We SHOULD NOT create a cell for every album and add it as a subview.
//	 I'm only doing this for speed. We can optimize it later. It will almost defintely need to be optimized for a device
//	 but we can get away with it for now in the simulator... Ideally, we would use no more than 3 cells at a time -
//	 next, current, and previous, and reuse reclaimed cells to avoid unecessary memory allocations...

	UIScrollView* albumView = self;

	// Note: We have to remove all the subviews, or we'll add dups if this method is called again!

	[self removeAllSubviewsFromView:albumView];
	
	NSUInteger totalWidth = 0;
	
	NSUInteger i = 0;
		
	for (NSString* anAlbum in albums)
	{		
		UIView* cell = [self albumCellForAlbum:anAlbum];
		
		if (!cell)
		{
			NSAssert1(NO, @"Could not get cell for artist %@", anAlbum);
			continue;
		}
		
		[albumView addSubview:cell];
		
		// IMPORTANT: we mark each album cell by its index, so when we later determine which cell
		// has been touched, we can get the index for that cell and look up its asscoiated
		// album name by index.
		
		cell.tag = i++;
				
		cell.frame = CGRectMake(totalWidth, 0, cell.frame.size.width, cell.frame.size.height);
		
		totalWidth += cell.frame.size.width;
	}

	[albumView setContentSize:CGSizeMake(totalWidth, albumView.bounds.size.height)];
		
	// Aesthetic: Center the album cells if necessary.
	/*if (totalWidth < albumView.bounds.size.width)
	{		
		const CGFloat offset = (albumView.bounds.size.width - totalWidth) / 2;

		// adjust content size to at least be as large as the bounds ?
		//[albumView setContentSize:CGSizeMake(albumView.bounds.size.width + offset, albumView.bounds.size.height)];

		[self horizontallyOffsetAllSubviews:offset];
	}*/

}

- (void) updateAlbums
{
	NSLog(@"%@ %@ for artist %@", [self class], NSStringFromSelector(_cmd), artist);
	
	albums = [self albumsForArtist:self.artist];;
	
	[albums retain];
	
	[self updateCells];
	
}

#pragma mark UIResponder Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{		
	UITouch* firstTouch = [touches anyObject];
		
	const NSInteger tag = [firstTouch view].tag;
	
	selectedAlbumIndex = (tag < 0) ? 0 : tag;
	
	// Note: the base class UIScrollView already has a delegate property which happens to
	// point to the vault view controller. We simply reuse the inherited delegate property
	// instead of introducing a new 'delegate-equivalent' property in this class just so
	// it can talk to the vault view controller.
	
	// $$$$$ maybe post a notification instead?
	
	if ([self.delegate respondsToSelector:@selector(updateAlbumSongsView)])
	{
		[self.delegate performSelector:@selector(updateAlbumSongsView)];
	}
}

#pragma mark Public Properties

- (void) setArtist:(NSString*)anArtist
{
	if (artist != anArtist)
	{
		[artist release];
		artist = [anArtist retain];
		
		[self updateAlbums];
		
		// IMPORTANT: select the first album for an artist when the artists changes.
		selectedAlbumIndex = 0;
	}
	
}

- (NSString*) artist
{
	return artist;
}

- (NSString*) album
{
	return (selectedAlbumIndex < [albums count]) ? [albums objectAtIndex:selectedAlbumIndex] : nil;
}

#pragma mark Object Life Cycle

- (void)dealloc
{	
	[albums release];
	[artist release];
	[prototypeAlbumCell release];
	
    [super dealloc];
}

@end
