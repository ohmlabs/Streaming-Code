//
//  CharacterIndex.h
//  ArtistIndex
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

// This class implements a localized character index.
// When the user touches, slides, or lifts their touch from
// the index, an action is sent to the specified target.
// The target can then ask the sender for the selected character.

@interface CharacterIndex : UIView
{
	@private
	
	__weak	id target;
			SEL action;

	NSArray* unicodeCharacters;
	NSInteger selectedIndex;
}

@property (readonly) unichar selectedCharacter;

// Set the unicode characters that should be displayed by this character index.
- (void)setCharacters:(NSArray*)unicodeCharacters;

// action will be called on target when the user touches this view.
- (void)addTarget:(id)target action:(SEL)action;

@end
