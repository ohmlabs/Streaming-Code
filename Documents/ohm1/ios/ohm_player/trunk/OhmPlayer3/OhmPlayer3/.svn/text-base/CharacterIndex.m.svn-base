//
//  CharacterIndex.m
//  ArtistIndex
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "CharacterIndex.h"
#import "OhmAppearance.h"

#include <objc/message.h> // For objc_msgSend

@implementation CharacterIndex

#pragma mark Properties

- (unichar) selectedCharacter
{
	// Returns the character at the selected index or the empty string.
	
	NSString* charString = (([unicodeCharacters count]) ? [unicodeCharacters objectAtIndex:selectedIndex] : nil);
	
	return (([charString length]) ? [charString characterAtIndex:0] : 'A');
}

#pragma mark Private Methods

- (void) removeAllSubviews
{
	// Removes existing glyph subviews so we don't add duplicate glyphs.
	
	for (UIView* view in self.subviews)
	{
		[view removeFromSuperview];
	}
}

#pragma mark Protected Methods

- (void) removePreviouslyDisplayedCharactersFromView
{
	[self removeAllSubviews];
}

- (void) addGlyphViews
{
	// Adds a glyph subview for each unicode character in this index.
	
	if (![unicodeCharacters count]) return;
	
	static	const CGFloat MinimumFontSize = 1.0F;
	
	const CGFloat height	= self.bounds.size.height;
	const CGFloat width		= self.bounds.size.width / (CGFloat)[unicodeCharacters count];
	
	NSUInteger i	= 0;
	
	for (NSString* unicodeChar in unicodeCharacters)
	{
		const CGRect frame	= CGRectMake(0, 0, width, height);
		
		UILabel* label		= [[UILabel alloc] initWithFrame:frame];
		
		 // IMPORTANT: If we don't enable user interaction and set
		 // opaque=YES for glyph views we can't do hit testing in
		 // touchesBegan later...
		
		label.opaque = YES;
		label.backgroundColor = [OhmAppearance characterIndexBackgroundColor];
		label.font = [OhmAppearance characterIndexFont];
		
		label.text = [unicodeCharacters objectAtIndex:i];
		label.textAlignment = UITextAlignmentCenter;
		label.minimumFontSize = MinimumFontSize;
		label.adjustsFontSizeToFitWidth = YES;
		label.userInteractionEnabled = YES;
		label.multipleTouchEnabled = NO;
		label.tag = (NSInteger)i++; // Store the character index in the view.

		label.textColor = [OhmAppearance characterIndexTextColor];
		[self addSubview:label];
		
	}
	
	[self setNeedsLayout];
}

- (void) highlightView
{
	// Highlights this view when the user touches it.
	
	//NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
}

- (void) unhighlightView
{
	// Removes highlighting from this view when the user stops touching it.
	
	//NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
}

- (void) performActionForSelectedCharacter
{
	// Performs an action on the target.
			
	//NSLog(@"Touched: %C", [self selectedCharacter]);
	
	//[target performSelector:action withObject:self]; // Note: we can't call performSelector with a generic action using ARC, we have to use objc_msgSend directly instead.

	if (action) objc_msgSend(target, action, self);
}

- (void) handleTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
	// Performs an action on the target when the selected character changes.
	
	NSParameterAssert(touch);
	
	if (!touch) return;
		
	UIView* touchedSubview = [self hitTest:[touch locationInView:self] withEvent:event];
	
	if (touchedSubview)
	{
		const NSInteger touchedCharacterIndex = touchedSubview.tag;
		
		if (selectedIndex != touchedCharacterIndex)
		{
			// Selected index has changed - post a change event.
			
			selectedIndex = touchedCharacterIndex;

			//NSLog(@"Character index is %ld, the char is %C", (long)touchedCharacterIndex, [self selectedCharacter]);
			
			[self performActionForSelectedCharacter];
		}

	}
	
}

#pragma mark UIView Methods

- (void)layoutSubviews
{	
	if (![unicodeCharacters count]) return;

	NSAssert([self.subviews count] == [unicodeCharacters count], @"Invalid number of subviews to layout.", nil);
	
	const CGFloat height	= self.bounds.size.height;
	const CGFloat width		= self.bounds.size.width / (CGFloat)[unicodeCharacters count];
	
	CGFloat x = 0.0F;
	
	for (UIView* v in self.subviews)
	{
		v.frame	= CGRectMake(x, 0, width, height);
		x += width;
	}
}

#pragma mark UIResponder Methods - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{			
	// When the user touches this view, visually indicate it's being touched.
	
	[self highlightView];
		
	[self handleTouch:[touches anyObject] withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self handleTouch:[touches anyObject] withEvent:event];
	
	// When the user's touch leaves this view, visually indicate it's no longer being touched.
	
	[self unhighlightView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self handleTouch:[touches anyObject] withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self unhighlightView];
}

#pragma mark Public Methods

- (void)setCharacters:(NSArray*)newUnicodeCharacters
{			
	unicodeCharacters = newUnicodeCharacters;
	
	[self removePreviouslyDisplayedCharactersFromView];

	[self addGlyphViews];
	
	[self setNeedsLayout];
}

- (void)addTarget:(id)aTarget action:(SEL)anAction
{
	target = aTarget;
	action = anAction;
}

@end
