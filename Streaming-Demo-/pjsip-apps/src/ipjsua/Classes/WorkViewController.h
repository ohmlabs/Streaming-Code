

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPLayer.h>
#import <AVFoundation/AVFoundation.h>


@interface WorkViewController : UIViewController <UITextFieldDelegate, MPMediaPickerControllerDelegate>
{
    UIButton *  _connectButton;
    UIButton *  _disconnectButton;
    UIButton *  _dropAllButton;
    UIButton *  _clearButton;
    UIButton *  _openPlayer;
    UIButton *  _stopMusic;
    UITextField * _sipClientAddress;
    
    UILabel     * _connectionCount;
    UILabel     * _sipAddress;
    
    UITextView  * _traceTextView;
 
    float       _prevMicLevel;
    
    UISwitch    *   _muteSwitch;
    UISwitch    *   _bridgeSwitch;
    
    MPMusicPlayerController *player;
}

@property (nonatomic, retain) IBOutlet UIButton *  connectButton;
@property (nonatomic, retain) IBOutlet UIButton *  disconnectButton;
@property (nonatomic, retain) IBOutlet UIButton *  dropAllButton;
@property (nonatomic, retain) IBOutlet UIButton *  clearButton;
@property (nonatomic, retain) IBOutlet UIButton *  openPlayer;
@property (nonatomic, retain) IBOutlet UIButton *  stopMusic;
@property (nonatomic, retain) IBOutlet UITextField * sipClientAddress;


@property (nonatomic, retain) IBOutlet UILabel     * connectionCount;
@property (nonatomic, retain) IBOutlet UILabel     * sipAddress;
@property (nonatomic, retain) IBOutlet UITextView  * traceTextView;
@property (nonatomic, retain) IBOutlet UISwitch    *  muteSwitch;
@property (nonatomic, retain) IBOutlet UISwitch    *  bridgeSwitch;

- (IBAction) connectButton_Click; 
- (IBAction) disconnectButton_Click;
- (IBAction) clearButton_Click;
- (IBAction) dropAllButton_Click;
- (IBAction) openMusicPicker_Click;
- (IBAction) stopMusic_Click;

- (IBAction) muteSwitchValueChanged:(id)sender; 
- (IBAction) bridgeSwitchValueChanged:(id)sender; 

- (void)playItemOverAudiUnit : (MPMediaItem* ) currentSong;


@end
