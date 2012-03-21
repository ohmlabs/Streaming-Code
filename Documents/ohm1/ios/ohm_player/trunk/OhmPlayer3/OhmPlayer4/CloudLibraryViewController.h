//
//  CloudLibraryViewController.h
//  OhmPlayer3
//
//  Created by Christopher Bennett on 3/4/12.
//  Copyright (c) 2012 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloudLibraryViewController : UIViewController {
    IBOutlet UIWebView *soundcloudlibrary;
}

@property(nonatomic) BOOL scalesPageToFit;

@property(nonatomic, readonly, retain) UIScrollView *scrollView;

@property(nonatomic) BOOL allowsInlineMediaPlayback;

@property(nonatomic) BOOL mediaPlaybackAllowsAirPlay;

@property(nonatomic) BOOL mediaPlaybackRequiresUserAction;


@end
