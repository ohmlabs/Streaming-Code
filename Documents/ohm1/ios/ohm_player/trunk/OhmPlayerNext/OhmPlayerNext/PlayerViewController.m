/*
 
 PlayerViewController.m
 
 DO NOT REMOVE THIS HEADER FROM THIS FILE.
 
 Ohm Labs, Inc. ("Ohm") is herby granted a world-wide, perpetual, royalty-free, non-transferable license to use this source code.
 This license header-comment must be preserved in each source file without modification. This source code may not be redistributed,
 published, or transferred without permission. Permission is herby granted to make this source code available to work-for-hire
 contractors, provided Ohm Labs, Inc. retains all rights and obligations specified by this license.
 
 Copyright 2011 Stormbring.
 
 */


#import "PlayerViewController.h"
#import "MusicQueue.h"

static NSString* NIB_NAME = @"PlayerViewController";
static NSString* fbAppId = @"170031159703872";

@implementation PlayerViewController

@synthesize facebook = _facebook;

#pragma mark Protected Methods

- (MusicQueue*)musicQueue
{
	return musicQueue();
}

#pragma mark Actions

- (IBAction)play
{
	[[self musicQueue] play];
    _playButton.hidden  = YES;
    _pauseButton.hidden = NO;
}

- (IBAction)pause
{
	[[self musicQueue] pause];
    _pauseButton.hidden = YES;
    _playButton.hidden  = NO;
}

- (IBAction)skipForward
{
    [[self musicQueue] skipToNextItem];
}

- (IBAction)skipBackward
{
	[[self musicQueue] skipToPreviousItem];
}

- (IBAction)fbPost
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithObject:@"please be nice to me" 
                                                                     forKey:@"message"];
    [_facebook dialog:@"feed" andParams:param andDelegate:self];
}

#pragma mark Object Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //custom initialization
    }
    return self;
}

- (id) init // Designated initializer.
{
	return [self initWithNibName:NIB_NAME bundle:nil];
}

- (void)dealloc
{
    [_facebook release];
    [_playButton release];
    [_pauseButton release];
    [_skipForwardButton release];
    [_skipBackwardButton release];
    [_repeatButton release];
    [_shuffleButton release];
    [_fbButton release];
    [_twitterButton release];
    [super dealloc];
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
    _facebook = [[Facebook alloc] initWithAppId:fbAppId];
    
    [_playButton         setImage: [UIImage imageNamed:@"pause_btn_down.png"]
                         forState: UIControlStateHighlighted];
    [_pauseButton        setImage: [UIImage imageNamed:@"play_btn_up.png"]
                         forState: UIControlStateHighlighted];
    [_skipForwardButton  setImage: [UIImage imageNamed:@"forward_btn_down.png"]
                         forState: UIControlStateHighlighted];
    [_skipBackwardButton setImage: [UIImage imageNamed:@"back_btn_down.png"]
                         forState: UIControlStateHighlighted];
    [_repeatButton       setImage: [UIImage imageNamed:@"repeat_down.png"]
                         forState: UIControlStateHighlighted];
    [_shuffleButton      setImage: [UIImage imageNamed:@"shuffle_down.png"]
                         forState: UIControlStateHighlighted];
    [_fbButton           setImage: [UIImage imageNamed:@"fb_down.png"]
                         forState: UIControlStateHighlighted];
    [_twitterButton      setImage: [UIImage imageNamed:@"twitter_down.png"]
                         forState: UIControlStateHighlighted];
    
    [super viewDidLoad];
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
