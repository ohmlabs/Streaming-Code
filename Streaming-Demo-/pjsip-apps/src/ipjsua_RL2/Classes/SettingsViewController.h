//
//  SettingsViewController.h
//  ipjsua
//
//  Created by Dmitry Bichan on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate;


@interface SettingsViewController : UIViewController 
{
    id<SettingsViewControllerDelegate> _delegate;    
    
    UITextField * _samplesPerFrameTextField;
    UITextField * _numChannelsTextField;
    UITextField * _clockRateTextField;      
    UITextField * _bitsPerSampleTextField;  
    
    
    NSInteger  _samplesPerFrame;
    NSInteger  _numChannels;
    NSInteger  _clockRate; 
    NSInteger  _bitsPerSample; 
}


@property (nonatomic, assign) id<SettingsViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField * samplesPerFrameTextField;
@property (nonatomic, retain) IBOutlet UITextField * numChannelsTextField;
@property (nonatomic, retain) IBOutlet UITextField * clockRateTextField; 
@property (nonatomic, retain) IBOutlet UITextField * bitsPerSampleTextField; 

@property (nonatomic, readwrite)  NSInteger  samplesPerFrame;
@property (nonatomic, readwrite)  NSInteger  numChannels;
@property (nonatomic, readwrite)  NSInteger  clockRate; 
@property (nonatomic, readwrite)  NSInteger  bitsPerSample; 



@end


@protocol SettingsViewControllerDelegate <NSObject>

- (void) settingsViewController:(SettingsViewController *)settingsViewController didSelectSettings:(NSDictionary*)settings;

@end