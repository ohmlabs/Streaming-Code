//
//  PlaylistsTransition.m
//  OhmPlayer3
//
//  Created by Christopher Bennett on 3/4/12.
//  Copyright (c) 2012 Ohm Labs. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PlaylistsTransition.h"

@implementation PlaylistsTransition

- (void)perform
{
	UIViewController *source = self.sourceViewController;
	UIViewController *destination = self.destinationViewController;
    
	// Create a UIImage with the contents of the destination
	UIGraphicsBeginImageContext(destination.view.bounds.size);
	[destination.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *destinationImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	// Add this image as a subview to the tab bar controller
	UIImageView *destinationImageView = [[UIImageView alloc] initWithImage:destinationImage];
	[source.parentViewController.view addSubview:destinationImageView];
    
    
	// Move the image outside the visible area
	CGPoint oldCenter = destinationImageView.center;
	CGPoint newCenter = CGPointMake(oldCenter.x - destinationImageView.bounds.size.width, oldCenter.y);
	destinationImageView.center = newCenter;
    
	// Start the animation
	[UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void)
     {
         destinationImageView.transform = CGAffineTransformIdentity;
         destinationImageView.center = oldCenter;
     }
                     completion: ^(BOOL done)
     {
         // Remove the image as we no longer need it
         [destinationImageView removeFromSuperview];
         
         // Properly present the new screen
         [source presentViewController:destination animated:NO completion:nil];
     }];
}

@end    