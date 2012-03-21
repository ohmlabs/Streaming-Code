/*
 
 PlayerViewController.h
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface PlayerViewController : UIViewController<FBSessionDelegate, FBDialogDelegate> {
    
    Facebook* _facebook;
    NSArray* _permissions;
    IBOutlet UIButton* _playButton;
    IBOutlet UIButton* _pauseButton;
    IBOutlet UIButton* _skipForwardButton;
    IBOutlet UIButton* _skipBackwardButton;
    IBOutlet UIButton* _repeatButton;
    IBOutlet UIButton* _shuffleButton;
    IBOutlet UIButton* _fbButton;
    IBOutlet UIButton* _twitterButton;
}

@property (nonatomic, retain) Facebook* facebook;

- (id) init; // Designated initializer.

- (IBAction) play;

- (IBAction) pause;

- (IBAction) skipForward;

- (IBAction) skipBackward;

- (IBAction) fbPost;

@end
