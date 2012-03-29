
#import <UIKit/UIKit.h>
#import "ConfigViewController.h"
#import "FirstViewController.h"
#import "TabBarController.h"
#import "WorkViewController.h"

@interface ipjsuaAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow		 *window;
    ConfigViewController *cfgView;
    FirstViewController  *mainView;
    TabBarController	 *tabBarController;
    WorkViewController   *workingViewController; 
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet ConfigViewController *cfgView;
@property (nonatomic, retain) FirstViewController *mainView;
@property (nonatomic, retain) IBOutlet WorkViewController  *workingViewController;


@end
