//
//  MainAppDelegate.h
//  Kiip Example
//
//  Created by Grantland Chew on 2/21/11.
//  Copyright 2011 Kiip, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface MainAppDelegate : NSObject <UIApplicationDelegate> {
    MainViewController *viewController;
    UINavigationController *navController;
    UIAlertView *alert;

    NSMutableArray *resources;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSMutableArray *resources;

@end

