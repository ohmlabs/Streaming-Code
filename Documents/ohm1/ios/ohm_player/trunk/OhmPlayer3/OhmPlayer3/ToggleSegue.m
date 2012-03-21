//
//  ToggleSegue.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "ToggleSegue.h"

// This segue is used to transition between the gallery's media and lists views.

@implementation ToggleSegue

- (void) perform
{
	UIViewController* sourceVC			= self.sourceViewController;
	UIViewController* destinationVC		= self.destinationViewController;
	
	UINavigationController* destinationsNavigationVC = sourceVC.navigationController;

	[destinationsNavigationVC popViewControllerAnimated:NO];
	[destinationsNavigationVC pushViewController:destinationVC animated:NO];

#if 1
	[UIView transitionWithView:destinationsNavigationVC.view duration:0.30F options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
			
		// There are no properties we're interesting in animating. Just the transition itself.
		
	} completion:NULL];
#endif
	
}

@end
