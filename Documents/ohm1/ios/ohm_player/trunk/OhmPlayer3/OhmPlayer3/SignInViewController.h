//
//  SignInViewController.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignInViewController;

@protocol SignInViewControllerDelegate <NSObject>

- (void)done:(SignInViewController*)signInViewController;

@end

@interface SignInViewController : UIViewController

- (IBAction)done:(id)sender;

@property (nonatomic, assign) IBOutlet id<SignInViewControllerDelegate> delegate;

@end
