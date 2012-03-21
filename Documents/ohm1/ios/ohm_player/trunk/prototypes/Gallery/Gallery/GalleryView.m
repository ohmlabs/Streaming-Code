//
//  GalleryView.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "GalleryView.h"

@implementation GalleryView

#pragma mark Properties

@synthesize dataSource;

#pragma mark Protected Methods

- (void) removeAllSubviews
{
	for (UIView* view in self.subviews)
	{
		[view removeFromSuperview];
	}
	
}

- (BOOL) delegateEnablesPaging
{
	if ([self.delegate conformsToProtocol:@protocol(GalleryViewDelegate)])
	{
		NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
											initWithTarget:self.delegate selector:@selector(shouldEnablePagingForGallery:)
											object:self];
		
		NSInvocation* invocation = [operation invocation];
		
		[invocation invoke];
		
		BOOL result = NO;
		
		[invocation getReturnValue:&result];
		
		return result;
	}
	
	return NO;
}

- (void) handleTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
	// Performs an action on the target when the selected character changes. ($$$$$?)
	
	NSParameterAssert(touch);
	
	if (!touch) return;
	
	UIView* touchedSubview = [self hitTest:[touch locationInView:self] withEvent:event];
	
	if (touchedSubview != self)
	{				
		id target = self.delegate;
		
		if ([target respondsToSelector:@selector(gallery:didSelectColumnAtIndex:)])
		{
			[target gallery:self didSelectColumnAtIndex:touchedSubview.tag];
		}
		
	}	
}

- (void) updateContentSizeWithAccumulatedWidth:(CGFloat)accumulatedWidth
{
	const CGFloat Width = (self.pagingEnabled) ? ([self.subviews count] * self.bounds.size.width) : accumulatedWidth;
	
	[self setContentSize:CGSizeMake(Width, self.bounds.size.height)];
}

- (void) loadCells
{
	[self removeAllSubviews];
	
	const NSUInteger NumberColumns = [dataSource numberOfColumnsInGallery:self];
	
	CGFloat accumulatedWidth = 0.0F;
	
	for (NSUInteger i = 0; i < NumberColumns; i++)
	{
		UIView* view = [dataSource gallery:self cellForColumnAtIndex:i];
		
		if (view)
		{
			view.tag = i;
			
			// IMPORTANT: we must enable user interaction so we can call hitTest:withEvent: later...
			
			view.userInteractionEnabled = YES;
			
			if (self.pagingEnabled)
			{
				// Only modify the cell's frame in paging mode.
				view.frame = CGRectOffset(self.bounds, self.bounds.size.width * i, 0);
			}
			
			accumulatedWidth += view.frame.size.width;
			
			[self addSubview:view];
		}
	}
	
	[self updateContentSizeWithAccumulatedWidth:accumulatedWidth];
	
	[self setNeedsLayout];
	
	shouldLayout = YES; // NOTE: Cocoa asks us to layout more often than is needed so we need to track
						// the need for layout ourselves for performance reasons...
	
}

#pragma mark UIScrollView Method - Override

- (void) setContentOffset:(CGPoint)contentOffset
{
	if (self.pagingEnabled)
	{
		// When paging is enabled and the orientation changes, the contentOffset becomes invalid
		// because the cell widths will be adjusted during relayout. In this case, the content offset
		// need to be adjusted as well to a multuiple of the new view bounds (i.e. multiples of the
		// page width).
		
		const UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
		
		if (orientation != lastSetContentOffsetOrientation)
		{		
			lastSetContentOffsetOrientation = [[UIApplication sharedApplication] statusBarOrientation];
			
			// The orientation has changed, hence the contentOffset is invalid.
			// We need to adjust it when pagingIsEnabled...
			
			contentOffset.x = floor(currentPage) * self.bounds.size.width;
			
		}
		else
		{
			// Same orientation: just calculate the new page number so it's
			// remembered the next time the orientation changes and we have to seek to the
			// last known 'current' page.
			
			currentPage = self.contentOffset.x / self.bounds.size.width;
		}
	}
	
	[super setContentOffset:contentOffset];
}

#pragma mark UIView Method - Override

- (void) layoutSubviews
{	
	const UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	if (shouldLayout || orientation != lastLayoutOrientation)
	{
		lastLayoutOrientation = [[UIApplication sharedApplication] statusBarOrientation];
		shouldLayout = NO;
		
		CGRect r = CGRectOffset(self.bounds, - self.contentOffset.x, 0);
		
		CGFloat accumulatedWidth = 0.0F;
		NSUInteger i = 0;
		for (UIView* view in self.subviews)
		{
			if (self.pagingEnabled)
			{
				view.frame = CGRectOffset(r, self.bounds.size.width * i++, 0);
			}
			else
			{
				CGRect newRect = view.frame;
				newRect.origin = CGPointZero;
				
				view.frame = CGRectOffset(newRect, accumulatedWidth, 0);
			}
			
			accumulatedWidth += view.frame.size.width;
		}
		
		[self updateContentSizeWithAccumulatedWidth:accumulatedWidth];
		
	}
}

#pragma mark UIResponder Methods - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{			
	[self handleTouch:[touches anyObject] withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
}

#pragma mark Public Methods

- (NSInteger) selectedIndex
{
	// Note: the center property of a scroll view is different than the center of its bounds.
	// We have to calculate the center of the bounds for hit testing.
	
	const CGPoint CenterOfBounds = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	
	UIView* centerSubview = [self hitTest:CenterOfBounds withEvent:nil];
	
	if (centerSubview != self)
	{
		return centerSubview.tag;
	}
	
	return -1;
}

- (void) reloadData
{
	[self loadCells];
}

#pragma mark Initialization

- (void) awakeFromNib
{		
	self.pagingEnabled = [self delegateEnablesPaging];
	
	[self reloadData];
	
}

@end
