//
//  Gallery.m
//  Gallery
//
//  Created by Reg on 8/13/11.
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "Gallery.h"

@implementation Gallery

#pragma mark Properties

@synthesize delegate;
@synthesize dataSource;

//- (CGFloat) previousOrientationsPage
//{
//	if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
//	{
//		return page_for_landscape_orientation;
//	}
//	else
//	{
//		return page_for_portrait_orientation;
//	}
//}
//
//- (void) setOrientationsCurrentPage:(CGFloat)page
//{
//	if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
//	{
//		page_for_portrait_orientation = page;
//	}
//	else
//	{
//		page_for_landscape_orientation = page;
//	}
//}

- (void) setContentOffset:(CGPoint)contentOffset
{
	static UIInterfaceOrientation lastOrientation = UIInterfaceOrientationPortrait;
	
	static CGFloat page = 0.0F;
	
	const UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	if (orientation != lastOrientation)
	{		
		lastOrientation = [[UIApplication sharedApplication] statusBarOrientation];
		
		NSLog(@"Changing orientation!");

		// the orientaiton has changed, hence the contentOffset is invalid. We need to adjust it
		// when pagingIsEnabled...
		
		contentOffset.x = floor(page) * self.bounds.size.width;
		
		return [super setContentOffset:contentOffset];

	}
	else
	{
		// same orientation, just calculate the new page number
		
		page = self.contentOffset.x / self.bounds.size.width;
	}
	
	[super setContentOffset:contentOffset];
}
//
//- (void) setContentOffset:(CGPoint)contentOffset
//{	
//	// The bounds might have already changed!
//
//	CGFloat newPage = self.contentOffset.x / self.bounds.size.width;
//
//	NSLog(@"setContentOffset page %f", newPage);
//
//	NSLog(@"Orientation: %@", 
//		  (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
//		  ? @"PORTRAIT" : @"LANDSCAPE");
//
//	NSLog(@"[BEFORE] setContentOffset page_for_portrait_orientation %f", page_for_portrait_orientation);
//	NSLog(@"[BEFORE] setContentOffset page_for_landscape_orientation %f", page_for_landscape_orientation);
//
//	[self setOrientationsCurrentPage:newPage];
//
//	//NSLog(@"Proposed content offset %@", NSStringFromCGPoint(contentOffset));
//	
//	NSLog(@"[AFTER] setContentOffset page_for_portrait_orientation %f", page_for_portrait_orientation);
//	NSLog(@"[AFTER] setContentOffset page_for_landscape_orientation %f", page_for_landscape_orientation);
//
//	//NSLog(@"Current bounds %@", NSStringFromCGRect(self.bounds));
//	
//	[super setContentOffset:contentOffset];
//
//}

#pragma mark Protected Methods

- (void) removeAllSubviews
{
	for (UIView* view in self.subviews)
	{
		[view removeFromSuperview];
	}
	
}

- (void) addCells
{
	[self removeAllSubviews];
	
	const NSUInteger NumberColumns = [dataSource numberOfColumnsInGallery:self];
	
	for (NSUInteger i = 0; i < NumberColumns; i++)
	{
		UIView* view = [dataSource gallery:self cellForColumnAtIndex:i];
		
		view.frame = CGRectOffset(self.bounds, self.bounds.size.width * i, 0);
		
		if (view)
		{
			view.tag = i;
			
			// IMPORTANT: we must enable user interaction so we can call hitTest:withEvent: later...
			
			view.userInteractionEnabled = YES;
			
			[self addSubview:view];
		}
	}
	
	[self setContentSize:CGSizeMake(NumberColumns * self.bounds.size.width, self.bounds.size.height)];

	[self setNeedsLayout];

}

- (void) handleTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
	// Performs an action on the target when the selected character changes. ($$$$$?)
	
	NSParameterAssert(touch);
	
	if (!touch) return;
	
	UIView* touchedSubview = [self hitTest:[touch locationInView:self] withEvent:event];
	
	if (touchedSubview)
	{
		NSLog(@"Touched item at index: %ld", (long)touchedSubview.tag);
	}	
}

- (void) layoutSubviews
{
	static UIInterfaceOrientation lastOrientation = UIInterfaceOrientationPortrait;

	const UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

	if (orientation != lastOrientation)
	{		
		lastOrientation = [[UIApplication sharedApplication] statusBarOrientation];

		NSLog(@"Changing orientation!");
		
		//NSLog(@"self.bounds %@", NSStringFromCGRect(self.bounds));
		//NSLog(@"Offset %@", NSStringFromCGPoint(self.contentOffset));
		
		CGRect r = CGRectOffset(self.bounds, - self.contentOffset.x, 0);
		
		//NSLog(@"Adjusted r %@", NSStringFromCGRect(r));

		NSUInteger i = 0;
		for (UIView* view in self.subviews)
		{
			//NSLog(@"view.frame [before] %@", NSStringFromCGRect(view.frame));
			view.frame = CGRectOffset(r, self.bounds.size.width * i++, 0);
			//NSLog(@"view.frame [after] %@", NSStringFromCGRect(view.frame));
		}
		
		[self setContentSize:CGSizeMake([self.subviews count] * self.bounds.size.width, self.bounds.size.height)];

		// adjust the content offset...
		//NSLog(@"POST: Content Offset %@", NSStringFromCGPoint(self.contentOffset));
		//NSLog(@"PREVIOUS Content page %f", [self previousOrientationsPage]);

		//[self setContentOffset:CGPointMake(floor([self previousOrientationsPage]) * self.bounds.size.width, self.contentOffset.y)];
	}

	
}

#pragma mark UIScrollView - Override

- (BOOL) isPagingEnabled
{
	if ([delegate conformsToProtocol:@protocol(GalleryDelegate)])
	{
		NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
											initWithTarget:delegate selector:@selector(shouldEnablePaging)
											object:nil];
		
		NSInvocation* invocation = [operation invocation];
		
		[invocation invoke];
		
		BOOL result = NO;
		
		[invocation getReturnValue:&result];
		
		return result;
	}
	
	return NO;
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

#pragma mark Initialization

- (void) awakeFromNib
{
	NSParameterAssert(dataSource);
		
	self.pagingEnabled = [self isPagingEnabled];

	[self addCells];
	
}

@end
