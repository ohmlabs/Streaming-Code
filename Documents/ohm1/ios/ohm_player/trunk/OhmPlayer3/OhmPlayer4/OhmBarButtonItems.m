//
//  OhmBarButtonItems.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "OhmBarButtonItems.h"

@implementation OhmBarButtonItems

#pragma mark Protected Methods

+ (UIBarButtonItem*) barButtonItemWithImage:(UIImage*)image target:(id)target action:(SEL)action
{
	NSParameterAssert(image);
	
	UIButton* button = nil;
	
	if (image)
	{
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:image forState:UIControlStateNormal];			
		button.frame = CGRectMake(0.0F, 0.0F, image.size.width, image.size.height);
		
		if (target || action)
		{
			[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
		}
	}
	
	return (button) ? [[UIBarButtonItem alloc] initWithCustomView:button] : nil;
}

#pragma mark Public Methods

+ (UIBarButtonItem*) barButtonItemWithImageNamed:(NSString*)imageName target:(id)target action:(SEL)action
{	
	// Note: it doesn't matter if we replace the UIBarButton item with a new object or attempt to customize the existing
	// button item by setting a new custom view. Once the custom view is set storyboard segues no longer fire.
	// The target must perform the segue manually in response to action.
	
	NSParameterAssert(imageName);
	
	UIBarButtonItem* barButtonItem = nil;
	
	if (imageName)
	{
		UIImage* image = [UIImage imageNamed:imageName];
		
		if (image)
		{
			barButtonItem = [OhmBarButtonItems barButtonItemWithImage:image target:target action:action];	
		}
	}
		
	return barButtonItem;
}

@end
