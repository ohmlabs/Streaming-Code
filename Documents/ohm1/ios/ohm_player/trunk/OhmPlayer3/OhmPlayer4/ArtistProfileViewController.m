//
//  ArtistProfileViewController.m
//  OhmPlayer3
//
//  Created by Christopher Bennett on 3/4/12.
//  Copyright (c) 2012 Ohm Labs. All rights reserved.
//

#import "ArtistProfileViewController.h"


@implementation ArtistProfileViewController

@synthesize scalesPageToFit;

@synthesize scrollView;

@synthesize allowsInlineMediaPlayback;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.scalesPageToFit = YES;
    self.scrollView;
    self.allowsInlineMediaPlayback = YES;
    [page loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ohmmusic.com/app"]]];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
