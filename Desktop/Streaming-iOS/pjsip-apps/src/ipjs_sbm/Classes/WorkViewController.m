

#import <pjlib.h>
#import <pjsua.h>
#import <pjmedia.h>
#import <pjmedia-codec.h>
#import <pjmedia-audiodev/audiodev_imp.h>
#import <pjlib-util.h>


#import "WorkViewController.h"


pj_thread_desc	a_thread_desc;
pj_thread_t		*a_thread;


@implementation WorkViewController

@synthesize connectButton = _connectButton;
@synthesize clearButton = _clearButton;
@synthesize disconnectButton = _disconnectButton;
@synthesize sipClientAddress = _sipClientAddress;

@synthesize connectionCount = _connectionCount;
@synthesize sipAddress = _sipAddress;
@synthesize traceTextView = _traceTextView;
@synthesize dropAllButton = _dropAllButton;
@synthesize muteSwitch = _muteSwitch;
@synthesize bridgeSwitch = _bridgeSwitch;
@synthesize openPlayer = _openPlayer;
@synthesize stopMusic = _stopMusic;
@synthesize accountUserName = _accountUserName;
@synthesize accountPassword = _accountPassword;


pj_status_t ex_pjsua_call_make_call(char *sip_address);
pj_status_t ex_pjsua_call_hangup_all(void);
pj_status_t ex_pjsua_call_hangup(void);

pj_status_t ex_pjsua_conf_adjust_rx_level(float level);
pj_status_t pjmedia_snd_init(pj_pool_factory *factory);
pj_status_t streamMusicTest(AudioBufferList *audioBufferList);
pj_status_t ex_pjsua_register_test(char* sipAddress, char* username);
pj_status_t logForMe(char *text);


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _prevMicLevel = 1.0;
        
    }
    return self;
}

- (void)dealloc
{
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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSTimer * t = [[[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(updateCurrentCallsNumber:) userInfo:nil repeats:YES] autorelease] ;
    [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
    
    
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

#pragma mark - Button Actions

- (IBAction) connectButton_Click
{      
    if (!pj_thread_is_registered())
    {
        pj_thread_register("ipjsua_1", a_thread_desc, &a_thread);
    }  
    ex_pjsua_call_make_call((char*)[_sipClientAddress.text cStringUsingEncoding:NSASCIIStringEncoding]);
}

- (IBAction) disconnectButton_Click
{
    if (!pj_thread_is_registered())
    {
        pj_thread_register("ipjsua_1", a_thread_desc, &a_thread);
    }  
    ex_pjsua_call_hangup();
}

- (IBAction) clearButton_Click
{
    [_traceTextView setText:@"Trace:"];
}

- (IBAction) dropAllButton_Click
{
    if (!pj_thread_is_registered())
    {
        pj_thread_register("ipjsua_1", a_thread_desc, &a_thread);
    } 
    ex_pjsua_call_hangup_all();
}

- (IBAction) muteSwitchValueChanged:(UISwitch*)sender;
{
    if (!pj_thread_is_registered())
    {
        pj_thread_register("ipjsua_1", a_thread_desc, &a_thread);
    } 
    if(sender.on)
    {
        ex_pjsua_conf_adjust_rx_level(0);
    }
    else
    {
        ex_pjsua_conf_adjust_rx_level(1);
    }
   
}

- (IBAction) bridgeSwitchValueChanged:(UISwitch*)sender
{
    if (!pj_thread_is_registered())
    {
        pj_thread_register("ipjsua_1", a_thread_desc, &a_thread);
    } 
    
    if(sender.on)
    {
        ex_make_bridge_for_all();
        
    }
    else
    {
        ex_destroy_bridge_for_all();
    }
}

- (IBAction) registerPhone_Click 
{
    [self registerSipAcount];
}

#pragma mark - Timer Fire

- (void) updateCurrentCallsNumber:(NSTimer*)theTimer
{
    static int _prevConnectionCount = 0;
    static BOOL _pjsipInitialized = NO;
    
    NSAutoreleasePool * releasePool = [[NSAutoreleasePool alloc] init];
    
    if(_prevConnectionCount != pjsua_call_get_count())
    {
        //переделываем конференцию
        if(_bridgeSwitch.on)
        {
             ex_destroy_bridge_for_all();
             ex_make_bridge_for_all();
            //[_bridgeSwitch setOn:NO];
        }
        
        _prevConnectionCount = (int)pjsua_call_get_count();
        
        [_connectionCount setText:[NSString stringWithFormat:@"%d", _prevConnectionCount]];
    }
    pjsua_acc_info info;
    
    if (!pj_thread_is_registered())
    {
        if( pj_thread_register("ipjsua_1", a_thread_desc, &a_thread) ==PJ_SUCCESS)
        {
            _pjsipInitialized = YES;
        }
    }
    
    if( _pjsipInitialized )
    {
        if(pjsua_acc_is_valid(0))
        {
            pjsua_acc_get_info(0, &info);
            
            [_sipAddress setText:[NSString stringWithFormat:@"%.*s",(int)info.acc_uri.slen, info.acc_uri.ptr]];
        }
    }
    [releasePool release];
    return;
}



#pragma mark - TextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


#pragma mark - Media Picker
- (void) registerSipAcount
{
    NSString *userNameSIP = [NSString stringWithFormat:@"sip:%@@sipsorcery.com",_accountUserName.text];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"03GoSlowly_MONO" ofType:@"wav"];
    NSLog(@"Path to wave file %@", path);
    
    _traceTextView.text =  path;
    
    ex_pjsua_register_test((char*) [userNameSIP UTF8String], (char*) [_accountUserName.text UTF8String]);

}

- (void) presentPicker {

    
    /*MPMediaPickerController* picker = [[MPMediaPickerController alloc] init];
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];*/
}

- (void) mediaPicker: (MPMediaPickerController*) mediaPicker
    didPickMediaItems: (MPMediaItemCollection*) mediaItemCollection {
    player = [MPMusicPlayerController applicationMusicPlayer];
    [player setQueueWithItemCollection:mediaItemCollection];
    [player play];
    [self playItemOverAudiUnit : [player nowPlayingItem] ]; 
    [self dismissModalViewControllerAnimated:YES];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController*) mediaPicker {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) openMusicPicker_Click 
{
    [self presentPicker];

}

- (void) stopMusic_Click 
{
    if (player != nil)  
        [player stop];

}

- (void)playItemOverAudiUnit : (MPMediaItem* ) currentSong  {
    //ex_pjsua_register_test();
}

- (void)playItemOverAudiUnit2 : (MPMediaItem* ) currentSong  {
    
    /*MPMediaQuery* album = [MPMediaQuery albumsQuery];
    NSArray *results = [album items];
    MPMediaItem *currentSong = nil;
    
    for (MPMediaItem* currentSong in results)
        NSLog(@"%@", [currentSong valueForProperty:MPMediaItemPropertyTitle]);
     */
    
    //MPMediaItem *currentSong = [myMusicController nowPlayingItem];
    
   
    
    NSURL *currentSongURL = [currentSong valueForProperty:MPMediaItemPropertyAssetURL];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:currentSongURL options:nil];
    NSError *error = nil;        
    AVAssetReader* reader = [[AVAssetReader alloc] initWithAsset:songAsset error:&error];
    
    AVAssetTrack* track = [[songAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    NSMutableDictionary* audioReadSettings = [NSMutableDictionary dictionary];
    [audioReadSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM]
                         forKey:AVFormatIDKey];
    
    AVAssetReaderTrackOutput* readerOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track outputSettings:audioReadSettings];
    [reader addOutput:readerOutput];
    [reader startReading];
    CMSampleBufferRef sample = [readerOutput copyNextSampleBuffer];
    while( sample != NULL )
    {
        sample = [readerOutput copyNextSampleBuffer];
        
        if( sample == NULL )
            continue;
        
        CMBlockBufferRef buffer = CMSampleBufferGetDataBuffer( sample );
        CMItemCount numSamplesInBuffer = CMSampleBufferGetNumSamples(sample);
        
        AudioBufferList audioBufferList;
        
        CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sample,
                                                                NULL,
                                                                &audioBufferList,
                                                                sizeof(audioBufferList),
                                                                NULL,
                                                                NULL,
                                                                kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment,
                                                                &buffer
                                                                );
        
        /*for (int bufferCount=0; bufferCount < audioBufferList.mNumberBuffers; bufferCount++) {
            SInt16* samples = (SInt16 *)audioBufferList.mBuffers[bufferCount].mData;
            for (int i=0; i < numSamplesInBuffer; i++) {
                NSLog(@"%i", samples[i]);
            }
        }*/
        
        //streamMusicTest(&audioBufferList);
        //Release the buffer when done with the samples 
        //(retained by CMSampleBufferGetAudioBufferListWithRetainedblockBuffer)
        CFRelease(buffer);             
        
        CFRelease( sample );
    }
    
}

@end
