

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPLayer.h>
#import <AVFoundation/AVFoundation.h>

#import "SettingsViewController.h"

@interface WorkViewController : UIViewController <UITextFieldDelegate, MPMediaPickerControllerDelegate, SettingsViewControllerDelegate>
{
    UIButton *  _connectButton;
    UIButton *  _disconnectButton;
    UIButton *  _dropAllButton;
    UIButton *  _clearButton;
    UITextField * _sipClientAddress;
    
    UILabel     * _connectionCount;
    UILabel     * _sipAddress;
    
    UITextView  * _traceTextView;
 
    float       _prevMicLevel;
    
    UISwitch    *   _muteSwitch;
    UISwitch    *   _bridgeSwitch;
    
    MPMusicPlayerController *player;
    
    int p_port;
    
    unsigned short numberOfChannels;
    unsigned long samplesPerFrame;
    unsigned short bitsPerSample; 
    unsigned int clockRate;
}

@property (nonatomic, retain) IBOutlet UIButton *  connectButton;
@property (nonatomic, retain) IBOutlet UIButton *  disconnectButton;
@property (nonatomic, retain) IBOutlet UIButton *  dropAllButton;
@property (nonatomic, retain) IBOutlet UIButton *  clearButton;
@property (nonatomic, retain) IBOutlet UITextField * sipClientAddress;


@property (nonatomic, retain) IBOutlet UILabel      * connectionCount;
@property (nonatomic, retain) IBOutlet UILabel     * sipAddress;
@property (nonatomic, retain) IBOutlet UITextView  * traceTextView;
@property (nonatomic, retain) IBOutlet UISwitch    *  muteSwitch;
@property (nonatomic, retain) IBOutlet UISwitch    *  bridgeSwitch;

- (IBAction) settingsButton_Click; 
- (IBAction) pickMusikButton_Click; 
- (IBAction) stopMusikButton_Click;
- (IBAction) connectButton_Click; 
- (IBAction) disconnectButton_Click;
- (IBAction) clearButton_Click;
- (IBAction) dropAllButton_Click;

- (IBAction) muteSwitchValueChanged:(id)sender; 
- (IBAction) bridgeSwitchValueChanged:(id)sender; 

@end
