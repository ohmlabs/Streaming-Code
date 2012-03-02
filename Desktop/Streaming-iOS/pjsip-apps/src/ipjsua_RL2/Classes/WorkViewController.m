

#import <pjlib.h>
#import <pjsua.h>

#import <pjmedia.h>
#import <pjmedia-codec.h>
#import <pjmedia-audiodev/audiodev_imp.h>
#import <pjlib-util.h>

#import "WorkViewController.h"
#import "WAVFileInMemory.h"

pj_thread_desc	a_thread_desc;
pj_thread_t		*a_thread;

@interface WorkViewController() 

- (void)playItemOverAudiUnit : (MPMediaItem* ) currentSong;

@end

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

pj_status_t ex_pjsua_call_make_call(char *sip_address);
pj_status_t ex_pjsua_call_hangup_all(void);
pj_status_t ex_pjsua_call_hangup(void);

pj_status_t ex_pjsua_conf_adjust_rx_level(float level);
pj_status_t pjmedia_snd_init(pj_pool_factory *factory);
pj_status_t streamMusicTest(AudioBufferList *audioBufferList);
pj_status_t ex_rem_sound_for_all(pjsua_conf_port_id  __call_port_src);
pj_status_t ex_manage_codec_prio(char *codec, char *prio);

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _prevMicLevel = 1.0;
        p_port = -1;
        
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
    
    numberOfChannels = 2;
    samplesPerFrame = 88704;
    bitsPerSample = 16; 
    clockRate = 44352;
    
    p_port = -1;
    // Do any additional setup after loading the view from its nib.
    
    ex_manage_codec_prio("L16/16000/1","250");
    
    NSTimer * t = [[[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(updateCurrentCallsNumber:) userInfo:nil repeats:YES] autorelease];
    
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

#pragma mark - SettingsViewController delegate

- (void) settingsViewController:(SettingsViewController *)settingsViewController didSelectSettings:(NSDictionary *)settings
{
    if(settings != nil)
    {
        int flag = 0;
        for (id key in [settings allKeys])
        {
            NSNumber * n = [settings objectForKey:key];
            if([n longValue] == 0)
            {
                flag = 1;
                break;
            }            
        }
        
        if(flag == 0)
        {
            clockRate = [[settings objectForKey:@"clock_rate"] longValue];
            bitsPerSample = [[settings objectForKey:@"bits_per_sample"] longValue];
            numberOfChannels = [[settings objectForKey:@"number_of_channels"] longValue];
            samplesPerFrame = [[settings objectForKey:@"samples_per_frame"] longValue];
        }
     }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Button Actions

- (IBAction) settingsButton_Click
{
    SettingsViewController *svc =[[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
    svc.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
    
    [svc setClockRate:clockRate];
    [svc setBitsPerSample:bitsPerSample];
    [svc setNumChannels:numberOfChannels];
    [svc setSamplesPerFrame:samplesPerFrame];
    
    svc.delegate = self;
    
    UINavigationController * newNavigationController = [[UINavigationController alloc] initWithRootViewController:svc];
    
    [self presentModalViewController:newNavigationController animated:YES];
    
    [newNavigationController release];
    
    
    [svc release];    
}

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


#pragma mark - Media Picker

- (void) presentPicker 
{
    MPMediaPickerController* picker = [[MPMediaPickerController alloc] init];
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void) mediaPicker: (MPMediaPickerController*) mediaPicker
   didPickMediaItems: (MPMediaItemCollection*) mediaItemCollection 
{
    if(player == nil)
    {
        player = [[MPMusicPlayerController alloc] init];
    }
    [player setQueueWithItemCollection:mediaItemCollection];
    [player play];
    [self playItemOverAudiUnit : [player nowPlayingItem] ];
    
    [self dismissModalViewControllerAnimated:YES];
    [player stop];
    [player release];
    player = nil;
}

- (void) mediaPickerDidCancel: (MPMediaPickerController*) mediaPicker 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction) pickMusikButton_Click
{  
    if(ex_get_current_call_id() == -1)
    {
        [self presentPicker];
        return;
    }
    
    static void * buffer = NULL;
    
    NSAutoreleasePool * releasePool = [[NSAutoreleasePool alloc] init];
     
    NSData * data = nil;
    
    NSArray *dirPaths;
    NSString *docsDir;
    NSString *newDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    newDir = [docsDir stringByAppendingPathComponent:@"file.pcm"];
   
    data = [NSData dataWithContentsOfFile:newDir];
    
    if(data == nil) 
    {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"" 
                                   message:@"Select a audio file when you not speak" 
                                  delegate:nil 
                         cancelButtonTitle:@"Ok" 
                         otherButtonTitles:nil, nil];
        [av show];
        [av release];
        return;
    }
    
    if(buffer != NULL)
    {
        free(buffer);
        buffer = NULL;
    }
    
    int buf_len = [data length];
    buffer = malloc(buf_len);
    
    NSLog(@">>>> Start copying in buffer");
    
    memcpy(buffer, [data bytes], buf_len);
    
    [releasePool release];
    
    static pj_pool_t * 	pool = NULL;
    
    if(pool == NULL)
    {
        pool = pjsua_pool_create("pjsua-app-mem-pool", 1024, 2048);
    }
    pjmedia_port * port;
    
    if(p_port != -1)
    {
        ex_rem_sound_for_all(p_port);
        p_port = -1;
    }
    
    // volume down
    
    SInt16 * iptr = (SInt16*)buffer;
    
    for(int i =0; i < buf_len/2; i++)
    {
        iptr[i] = iptr[i]/4;
    }
    
    pjsua_conf_port_id t = pjmedia_mem_player_create (pool, 
                                                 buffer, 
                                                 buf_len, 
                                                 clockRate              /*44352 clock_rate*/, 
                                                 numberOfChannels       /* 	channel_count*/, 
                                                 samplesPerFrame        /* 	samples_per_frame*/, 
                                                 bitsPerSample          /*	bits_per_sample*/, 
                                                 1                      /*	options*/, 
                                                 &port);
    //if(t == 0)
    {
        p_port = ex_add_sound_for_all(port);  
    }  
}


- (IBAction) stopMusikButton_Click
{
    if(p_port != -1)
    {
        ex_rem_sound_for_all(p_port);
        p_port = -1;
    }
}

- (void)playItemOverAudiUnit : (MPMediaItem* ) currentSong  
{
    static int total = 0;
    
    NSAutoreleasePool * releasePool = [[NSAutoreleasePool alloc] init];
    
    NSURL *currentSongURL = [currentSong valueForProperty:MPMediaItemPropertyAssetURL];
    
    NSLog(@"%@",currentSongURL);
    
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
    
    total = 0;
    
    NSMutableData * mutableData = [NSMutableData data];
    
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
        
        for (int bufferCount=0; bufferCount < audioBufferList.mNumberBuffers; bufferCount++) 
        {            
            SInt16* samples = (SInt16 *)audioBufferList.mBuffers[bufferCount].mData;
            //NSLog(@"buffers:%i\t\tsamples:%i\t\t",bufferCount,numSamplesInBuffer);
            total += numSamplesInBuffer;
            [mutableData appendBytes:samples 
                              length:audioBufferList.mBuffers[bufferCount].mDataByteSize];
        }
        //Release the buffer when done with the samples 
        //(retained by CMSampleBufferGetAudioBufferListWithRetainedblockBuffer)
        CFRelease(buffer);             
        
        CFRelease( sample );
    }
    
    NSArray *dirPaths;
    NSString *docsDir;
    NSString *newDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                   NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    newDir = [docsDir stringByAppendingPathComponent:@"file.pcm"];
    
    [mutableData writeToFile:newDir atomically:YES];
    
    [releasePool release];    
}



#pragma mark - TextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
