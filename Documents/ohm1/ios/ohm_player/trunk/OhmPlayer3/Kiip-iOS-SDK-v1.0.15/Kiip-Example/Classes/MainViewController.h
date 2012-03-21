//
//  MainViewController.h
//  Kiip Example
//
//  Created by Grantland Chew on 2/21/11.
//  Copyright 2011 Kiip, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kiip.h"

@interface MainViewController : UIViewController <KPManagerDelegate> {
	IBOutlet UITextField *leaderboard_id;
	IBOutlet UITextField *achievement_id;
    IBOutlet UISwitch *toggleAction;
    IBOutlet UISwitch *toggleStatusBar;

    KPViewPosition kpViewPosition;
}

@property (nonatomic, retain) UISwitch *toggleAction;

- (IBAction)setLocation;
- (IBAction)unlockAchievement;
- (IBAction)saveLeaderboard;
- (IBAction)showNotification;
- (IBAction)showFullscreen;
- (IBAction)toggleStatusBar;

@end

