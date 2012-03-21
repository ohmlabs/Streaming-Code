//
//  ArtistProfileViewController.h
//  OhmPlayer3
//
//  Created by Christopher Bennett on 3/4/12.
//  Copyright (c) 2012 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistProfileViewController : UIViewController {
    IBOutlet UIWebView *page;
}

@property(nonatomic) BOOL scalesPageToFit;

@property(nonatomic, readonly, retain) UIScrollView *scrollView;

@property(nonatomic) BOOL allowsInlineMediaPlayback;


@end
