//
//  SettingsViewController.m
//  ipjsua
//
//  Created by Dmitry Bichan on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

@synthesize  delegate = _delegate;

@synthesize samplesPerFrameTextField = _samplesPerFrameTextField;
@synthesize bitsPerSampleTextField = _bitsPerSampleTextField;
@synthesize numChannelsTextField = _numChannelsTextField;
@synthesize clockRateTextField = _clockRateTextField;

@synthesize samplesPerFrame = _samplesPerFrame;
@synthesize bitsPerSample   = _bitsPerSample;
@synthesize numChannels     = _numChannels;
@synthesize clockRate       = _clockRate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void) ept
{
    UIBarButtonItem *bi = nil;
    bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                       target:self
                                                       action:@selector(barButtonDone_Click:)];
    self.navigationItem.rightBarButtonItem = bi;
    [bi release];
    
    bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                       target:self 
                                                       action:@selector(barButtonCancel_Click:)];
    self.navigationItem.leftBarButtonItem = bi;
    [bi release];    
}



#pragma mark - Buttons Actions

- (void) barButtonCancel_Click:(id)sender
{
    if([_delegate respondsToSelector:@selector(settingsViewController:didSelectSettings:)])
    {
        [_delegate settingsViewController:self didSelectSettings:nil];
    }
}

- (void) barButtonDone_Click:(id)sender
{
    if([_delegate respondsToSelector:@selector(settingsViewController:didSelectSettings:)])
    {
        NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionary];
        
        [mutableDictionary setObject:[NSNumber numberWithLongLong:[_samplesPerFrameTextField.text longLongValue]] 
                              forKey:@"samples_per_frame"];        
        [mutableDictionary setObject:[NSNumber numberWithLongLong:[_numChannelsTextField.text longLongValue]]
                              forKey:@"number_of_channels"];
        [mutableDictionary setObject:[NSNumber numberWithLongLong:[_clockRateTextField.text longLongValue]]   
                              forKey:@"clock_rate"];
        [mutableDictionary setObject:[NSNumber numberWithLongLong:[_bitsPerSampleTextField.text longLongValue]] 
                              forKey:@"bits_per_sample"];
        
        [_delegate settingsViewController:nil didSelectSettings:[NSDictionary dictionaryWithDictionary:mutableDictionary]];
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    [_samplesPerFrameTextField release];
    [_numChannelsTextField release];
    [_clockRateTextField release];      
    [_bitsPerSampleTextField release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_clockRateTextField setText:[NSString stringWithFormat:@"%d",_clockRate]];
    [_bitsPerSampleTextField setText:[NSString stringWithFormat:@"%d",_bitsPerSample]];
    [_numChannelsTextField setText:[NSString stringWithFormat:@"%d",_numChannels]];
    [_samplesPerFrameTextField setText:[NSString stringWithFormat:@"%d",_samplesPerFrame]];
    
    [self ept];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
