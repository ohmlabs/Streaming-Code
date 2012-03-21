//
//  MainAppDelegate.m
//  Kiip Example
//
//  Created by Grantland Chew on 2/21/11.
//  Copyright 2011 Kiip, Inc. All rights reserved.
//

#import "MainAppDelegate.h"
#import "MainViewController.h"

#import "Kiip.h"

@interface MainAppDelegate (Private) <KPManagerDelegate>

- (void) initializeKiip;

@end

@implementation MainAppDelegate

@synthesize window=window_;
@synthesize resources;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Add the view controller's view to the window and display.
    viewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    navController = [[UINavigationController alloc] initWithRootViewController:viewController];

    [self.window addSubview:navController.view];
    [self.window makeKeyAndVisible];

    [self initializeKiip];
    resources = [[NSMutableArray alloc] init];

    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [navController release];
    [alert release];
    [resources release];
    [super dealloc];
}

//==============================================================================
#pragma mark -
#pragma mark Kiip
//==============================================================================

- (void) initializeKiip {
    // Initialize Kiip Session
    KPManager* manager = [[KPManager alloc] initWithKey:KP_APP_KEY secret:KP_APP_SECRET testFrequency:100];
    [KPManager setSharedManager:manager];
    [manager setDelegate:self];
    [manager release];
}

//==============================================================================
#pragma mark -
#pragma mark KPManagerDelegate callbacks
//==============================================================================

- (void) manager:(KPManager*)manager didStartSession:(NSDictionary*)resource {
    NSLog(@"Delegate: managerDidStartSession: %@", resource);

    if (resource == nil) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Kiip"
                 message:@"Session Created\n\n(No Promo)"
                 delegate:self
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
    } else {
        NSMutableDictionary* reward = [NSMutableDictionary dictionaryWithDictionary:resource];
        [reward setObject:[NSNumber numberWithInt:kKPViewPosition_FullScreen] forKey:@"position"];
        [[KPManager sharedManager] presentReward:reward];

        alert = [[UIAlertView alloc]
                 initWithTitle:@"Kiip"
                 message:@"Session Created\n\n(w/ Promo)"
                 delegate:self
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
    }

    [alert show];
}

- (void) managerDidUpdateLocation:(KPManager*)manager {
    NSLog(@"Delegate: managerDidUpdateLocation");
}

- (void) managerDidEndSession:(KPManager*)manager {
    NSLog(@"Delegate: managerDidCloseSession");
}

- (void) manager:(KPManager*)manager didGetActivePromos:(NSArray*)promos {
    NSLog(@"Delegate: didGetActivePromos: %@", promos);
}

- (void) manager:(KPManager*)manager didUnlockAchievement:(NSDictionary*)resource {
    /**
     * Note: By overriding this method, we must call presentReward ourselves.
     */
    NSLog(@"Delegate: didUnlockAchievement: %@", resource);
    if(resource != nil) {
        [resources addObject:resource];
        if(viewController.toggleAction.on) {
            [manager presentReward:resource];
        }
    } else {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Kiip"
                 message:@"No reward recieved"
                 delegate:self
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
        [alert show];
    }
}

- (void) manager:(KPManager*)manager didUpdateLeaderboard:(NSDictionary*)resource {
    /**
     * Note: By overriding this method, we must call presentReward ourselves.
     */
    NSLog(@"Delegate: didUpdateLeaderboard: %@", resource);
    if(resource != nil) {
        [resources addObject:resource];
        if(viewController.toggleAction.on) {
            [manager presentReward:resource];
        }
    } else {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Kiip"
                 message:@"No reward recieved"
                 delegate:self
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
        [alert show];
    }
}

- (void) manager:(KPManager*)manager didReceiveError:(NSError*)error {
    NSLog(@"Delegate: error(%d): %@", [error code], [error userInfo]);
    alert = [[UIAlertView alloc]
             initWithTitle:[NSString stringWithFormat:@"Kiip Error: %d", [error code]]
             message:[NSString stringWithFormat:@"%@", [[error userInfo] objectForKey:@"message"]]
             delegate:self
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil];
    [alert show];
}

- (void) willPresentNotification:(NSString*)rid {
    NSLog(@"Delegate: willPresentNotification");
}

- (void) didPresentNotification:(NSString*)rid {
    NSLog(@"Delegate: didPresentNotification");
}

- (void) willCloseNotification:(NSString*)rid {
    NSLog(@"Delegate: willCloseNotification");
}

- (void) didCloseNotification:(NSString*)rid {
    NSLog(@"Delegate: didCloseNotification");
}

- (void) willShowWebView:(NSString*)rid {
    NSLog(@"Delegate: willShowWebView");
}

- (void) didShowWebView:(NSString*)rid {
    NSLog(@"Delegate: didShowWebView");
}

- (void) willCloseWebView:(NSString*)rid {
    NSLog(@"Delegate: willCloseWebView");
}

- (void) didCloseWebView:(NSString*)rid {
    NSLog(@"Delegate: didCloseWebView");
}

- (void) didStartSwarm:(NSString *)leaderboard_id {
    NSLog(@"Delegate: didStartSwarm: %@", leaderboard_id);

    alert = [[UIAlertView alloc]
             initWithTitle:@"Kiip"
             message:[NSString stringWithFormat:@"Swarm Delegate: %@", leaderboard_id]
             delegate:self
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil];
    [alert show];
}

- (void) didReceiveContent:(NSString*)content quantity:(int)quantity withReceipt:(NSDictionary *)receipt {
    NSLog(@"Delegate: didReceiveContent:%@ quantity:%d receipt:%@", content, quantity, receipt);

    alert = [[UIAlertView alloc]
             initWithTitle:@"Kiip"
             message:[NSString stringWithFormat:@"Content Delegate: %d %@", quantity, content]
             delegate:self
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil];
    [alert show];
}

@end
