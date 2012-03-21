/*
 
 VaultArtistIndexView.m
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import "VaultArtistIndexView.h"

static const char ASCII_DECIMAL_A = 65;

@implementation VaultArtistIndexView

#pragma mark Synthesized Properties

@synthesize selectedChar;

#pragma mark Protected Methods

- (void) highlightView
{
	// TBD - visibly display this view in a touched state.
}

- (void) unHighlightView
{
	// TBD - visibly display this view in an untouched state.
}

- (NSArray*) fallbackIndexChars
{
	// This roman character specific index should only be used if Apple's
	// [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] method
	// returns nil.

	#define NumRomanLetters 26
	
	static const NSUInteger NumIndexChars	= NumRomanLetters + 1; // Make room for a # char.
	
	NSMutableArray* indexChars = [NSMutableArray arrayWithCapacity:NumIndexChars];
	
	for (NSUInteger i = 0; i < NumRomanLetters; i++)
	{
		const unichar c = ASCII_DECIMAL_A + i;
		
		NSString* strChar = [NSString stringWithFormat:@"%C", c];
		
		NSAssert3(strChar, @"Could not create an index at index %u, ascii %u (unichar = %C)", i, c, c);
		
		if (strChar) [indexChars addObject:strChar];
	}
	
	// Apple's collated indexes include # at the end, so we include it as well to match.
	
	//[indexChars addObject:[NSString stringWithString:@"#"]];
	
	// $$$$$ Temporarily mimic the Ohm charactert index graphic so the hit testing code can be tested.
	// We'll remove this code when we're using an fallback character set the match Apple's.
	// i.e. when the index view becomes responsible for *drawing* the character index, as opposed
	// to using a static graphic image.
	
	[indexChars insertObject:[NSString stringWithString:@"#"] atIndex:0];
	[indexChars addObject:[NSString stringWithString:@"?"]];
	
	return indexChars;
}

- (NSArray*) localizedSectionIndexChars
{
	if (!sectionIndexChars)
	{
		// $$$$$ This method should return an array of NSStrings returned by 
		// [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]
		// but only if this class is prepared to visually populate its bounds
		// using the identical string values...
		
		//sectionIndexChars = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
		
		if (![sectionIndexChars count])
		{
			sectionIndexChars = [self fallbackIndexChars];
		}
		
		[sectionIndexChars retain];
	}
	
	return sectionIndexChars;
}

- (const unichar) characterAtTouchPointInView:(const CGPoint)touchPointInView
{	
	// Get a localized array of index characters.
	
	NSArray* indexChars = [self localizedSectionIndexChars];
	
	// If we don't have a localized index, return ASCII A.
	
	if (![indexChars count]) return ASCII_DECIMAL_A;
		
	// Otherwise, calculate which index character is being touched and return it.
		
	const NSUInteger CharacterWidth		= (NSUInteger)self.frame.size.width / [indexChars count];
	const NSUInteger CharacterInset		= CharacterWidth / 2;
		
	NSUInteger characterOffset = 0;
	
	if (CharacterWidth) // avoid division by zero.
	{
		const NSUInteger x = (NSUInteger)touchPointInView.x;
		
		if (x < CharacterInset) // avoid subtraction underflow
		{
			characterOffset = 0;
		}
		else
		{
			characterOffset = (x - CharacterInset) / CharacterWidth;
		}
		
	}
	
	NSString* unicodeCharacter = (characterOffset >= [indexChars count]) 
	? [indexChars lastObject] 
	: [indexChars objectAtIndex:characterOffset];
	
	return ([unicodeCharacter length]) ? [unicodeCharacter characterAtIndex:0] : ASCII_DECIMAL_A;
}

- (void)seekToArtistsInResponseToTouches:(NSSet *)touches
{	
	// Calculate which character is being touched.
	
	const CGPoint touchPointInView = [[touches anyObject] locationInView:self];
	
	selectedChar = [self characterAtTouchPointInView:touchPointInView];
		
	NSLog(@"Touched char %C", selectedChar);
	
	// Inform the target this view has been touched. The target can call us back and ask for the selected character.
	
	[target performSelector:action withObject:self];
}

#pragma mark UIResponder Methods - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{			
	// When the user touches this view, visually indicate it's being touched.
	
	[self highlightView];

	[self seekToArtistsInResponseToTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self seekToArtistsInResponseToTouches:touches];

	// When the user's touch leaves this view, visually indicate it's no longer being touched.

	[self unHighlightView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self seekToArtistsInResponseToTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

#pragma mark Public Methods

- (void)addTarget:(id)aTarget action:(SEL)anAction
{
	target = aTarget;
	action = anAction;
}

#pragma mark Object Life Cycle

- (void)dealloc
{	
	[sectionIndexChars release];
    [super dealloc];
}

@end
