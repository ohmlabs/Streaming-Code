//
//  SongTableViewSupport.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "SongsTableViewSupport.h"

static NSString* const ADD_BUTTON_IMAGE_NAME = @"add_button";

@implementation SongsTableViewSupport

#pragma mark Protected Methods

- (UIImage*) songAccessoryImage
{	
	if (!songCellAccessoryImage)
	{
		songCellAccessoryImage = [UIImage imageNamed:ADD_BUTTON_IMAGE_NAME];
	}
	
	return songCellAccessoryImage;
}

- (UIView*) addButtonAccessoryViewWithTarget:(id)target
{
	UIImage* image = [self songAccessoryImage];
	
	NSParameterAssert(image);
	
	if (image)
	{
		UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
		
		button.frame = CGRectMake(0, 0, 44, 44); // ISSUE: hard code constants. No know way to calculate...
		
		[button setImage:image forState:UIControlStateNormal];
		
		[button addTarget:target action:@selector(addSongButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		
		return button;
	}
	
	return nil;
}

#pragma mark Public Methods

- (UIView*) accessoryButtonViewWithTarget:(id)target
{	
	return (target) ? [self addButtonAccessoryViewWithTarget:target] : nil;
}

@end
