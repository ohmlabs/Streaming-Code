//
//  CloudLibraryViewController.m
//  OhmPlayer3
//
//  Created by Christopher Bennett on 3/4/12.
//  Copyright (c) 2012 Ohm Labs. All rights reserved.
//

#import "CloudLibraryViewController.h"

@implementation CloudLibraryViewController

@synthesize scalesPageToFit;

@synthesize scrollView;

@synthesize allowsInlineMediaPlayback;

@synthesize mediaPlaybackAllowsAirPlay;

@synthesize mediaPlaybackRequiresUserAction;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.scalesPageToFit = YES;
    self.scrollView;
    self.allowsInlineMediaPlayback = YES;
    [soundcloudlibrary loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.soundcloud.com"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
