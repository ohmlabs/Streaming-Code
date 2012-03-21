//
//  MainViewController.m
//  Kiip Example
//
//  Created by Grantland Chew on 2/21/11.
//  Copyright 2011 Kiip, Inc. All rights reserved.
//

#import "MainAppDelegate.h"
#import "MainViewController.h"
#import "Kiip.h"

@implementation MainViewController

@synthesize toggleAction;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = KPManagerVersion;
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    kpViewPosition = kKPViewPosition_Top;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[KPManager sharedManager] setGlobalOrientation:(UIDeviceOrientation)interfaceOrientation];
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

//==============================================================================
#pragma mark -
#pragma mark UI actions
//==============================================================================

- (IBAction)getActivePromos {
    NSLog(@"get active promos");
    kpViewPosition = (kpViewPosition == kKPViewPosition_Top) ? kKPViewPosition_Bottom : kKPViewPosition_Top;
    [[KPManager sharedManager] getActivePromos];
}

- (IBAction)setLocation {
    NSLog(@"set location");
    [[KPManager sharedManager] updateLatitude:(double)37.7753 longitude:(double)-122.4189];
}

- (IBAction)unlockAchievement {
    NSLog(@"unlock achievement");
    [[KPManager sharedManager] unlockAchievement:achievement_id.text withTags:[NSArray arrayWithObjects:@"movies", @"music", nil]];
}

- (IBAction)saveLeaderboard {
    NSLog(@"save leaderboard");
    [[KPManager sharedManager] updateScore:100 onLeaderboard:leaderboard_id.text];
}

- (IBAction)showNotification {
    NSLog(@"show notification");
    MainAppDelegate *appDelegate = (MainAppDelegate *)[[UIApplication sharedApplication] delegate];

    kpViewPosition = (kpViewPosition == kKPViewPosition_Top) ? kKPViewPosition_Bottom : kKPViewPosition_Top;
    NSMutableArray *queue = [appDelegate resources];
    NSLog(@"queue length: %d", [queue count]);
    while ([queue count] > 0) {
        NSMutableDictionary* reward = [NSMutableDictionary dictionaryWithDictionary:[queue objectAtIndex:[queue count] - 1]];
        [reward setObject:[NSNumber numberWithInt:kpViewPosition] forKey:@"position"];

        [[KPManager sharedManager] presentReward:reward];
        [queue removeObjectAtIndex:[queue count] - 1];
    }
}

- (IBAction)showFullscreen {
    NSLog(@"show fullscreen");
    MainAppDelegate *appDelegate = (MainAppDelegate *)[[UIApplication sharedApplication] delegate];

    NSMutableArray *queue = [appDelegate resources];
    while ([queue count] > 0) {
        NSMutableDictionary* reward = [NSMutableDictionary dictionaryWithDictionary:[queue objectAtIndex:[queue count] - 1]];
        [reward setObject:[NSNumber numberWithInt:kKPViewPosition_FullScreen] forKey:@"position"];

        [[KPManager sharedManager] presentReward:reward];
        [queue removeObjectAtIndex:[queue count] - 1];
    }
}

- (IBAction)toggleStatusBar {
    if(toggleStatusBar.on) {
        //NSLog(@"Changing Status Bar: Show");
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    else {
        //NSLog(@"Changing Status Bar: Hide");
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

@end
