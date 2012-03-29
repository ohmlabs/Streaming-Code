//
//  ictestViewController.h
//  smallsip3
//
//  Created by Simon Boyce-Maynard on 11/29/11.
//  Copyright (c) 2011 Cognizant Technology Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPLayer.h>
#import <AVFoundation/AVFoundation.h>

@interface ictestViewController : UIViewController <UITextFieldDelegate, MPMediaPickerControllerDelegate>
{
    IBOutlet UIButton *goButton;
    IBOutlet UIButton *initButton;
    IBOutlet UIButton *playFile;
    IBOutlet UIButton *showInfo;
    IBOutlet UIButton *dumpData;
    IBOutlet UITextField *fbField;
    IBOutlet UITextField *ohmFriend;
    IBOutlet UITextField *sourceNumberTextField;
    IBOutlet UITextField *destinationNumberTextField;
    IBOutlet UITextField *codecNameTextField;
    IBOutlet UITextField *clockRateTextField;
    AVPlayer *audioPlayerMusic;
    

    
}

@property (nonatomic, retain) UITextField *fbField;
@property (nonatomic, retain) UITextField *ohmFriend;
@property (nonatomic, retain) UITextField *sourceNumberTextField;
@property (nonatomic, retain) UITextField *destinationNumberTextField;
@property (nonatomic, retain) UITextField *codecNameTextField;
@property (nonatomic, retain) UITextField *clockRateTextField;


- (IBAction) startTraceClick:(id)sender;
- (IBAction) callTraceClick:(id)sender;
- (IBAction) invokePlayFile:(id)sender;
- (IBAction) showInfo:(id)sender;
- (IBAction) linkPorts:(id)sender;
- (IBAction) unlinkPorts:(id)sender;
- (IBAction) dumpCurrentCallInfo:(id)sender;
- (IBAction) openMusicPicker:(id)sender;
- (void) presentPicker;
- (void) mediaPicker: (MPMediaPickerController*) mediaPicker didPickMediaItems: (MPMediaItemCollection*) mediaItemCollection;
- (void) mediaPickerDidCancel: (MPMediaPickerController*) mediaPicker;
- (void) sampleTestStuff : (NSURL*)currentSongURL;
- (void) playItemOverAudiUnit : (MPMediaItem* ) currentSong;

- (NSString*) getIPAddress;


@end
