//
//  ictestViewController.m
//  smallsip3
//
//  Created by Simon Boyce-Maynard on 11/29/11.
//  Copyright (c) 2011 Cognizant Technology Solutions. All rights reserved.
//

#import "ictestViewController.h"

#include <pjsua-lib/pjsua.h>
#include <pjlib.h>
#include <pjlib-util.h>
#include <pjmedia.h>
#include <pjmedia-codec.h>
#include <pjmedia/transport_srtp.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation ictestViewController


@synthesize fbField;
@synthesize ohmFriend;
@synthesize sourceNumberTextField;
@synthesize destinationNumberTextField;
@synthesize codecNameTextField;
@synthesize clockRateTextField;

#define THIS_FILE	"SmallSip3"
#define SIP_DOMAIN	"sipsorcery.com"
#define SIP_PASSWD	"password"
#define NO_LIMIT	(int)0x7FFFFFFF
#define LC_CLOCK_RATE "16000"
#define LC_CODEC "L16"
#define LC_CHANNELS "1"

char* SIP_USER;
char *codec_id = "PCMU/8000/1";
int DEFAULT_CLOCK_RATE = 8000;
bool hostMode = false;  

static char some_buf[1024 * 3];
int _last_call_id;
pjsua_acc_id acc_id;
pj_status_t status;
pj_caching_pool cp;
pjmedia_endpt *med_endpt;
pj_pool_t *pool;
pjmedia_port *file_port;
pjmedia_snd_port *snd_port;
pjmedia_conf *pjm_conf;
pjsua_logging_config    pjsua_log_cfg;
pjsua_media_config	    pjsua_media_cfg;
pjsua_conf_port_id mysong_port;
const pjmedia_codec_info *codec_info;
pj_status_t pjsip_register(char* _sipURI, char *_name);
pj_status_t callSipAddress(char *sip_uri);
void conf_list(pjmedia_conf *conf, int detail);
int invokePlayFile(NSString *filePath);
pj_status_t create_stream( pj_pool_t *pool,
                          pjmedia_endpt *med_endpt,
                          const pjmedia_codec_info *codec_info,
                          pjmedia_dir dir,
                          pj_uint16_t local_port,
                          const pj_sockaddr_in *rem_addr,
                          pjmedia_stream **p_stream );
pj_status_t init_codecs(pjmedia_endpt *med_endpt);
void log_call_dump(int call_id);
pj_status_t init_pjpservices(char* _lcodec, int _lclockrate );
pj_status_t pjusa_conf_list(void);
pj_status_t on_memplayer_complete(pjmedia_port *port, void *usr_data);

bool initCompleted = false;
AudioBufferList audioBufferList;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - Media Selection

- (void) presentPicker 
{
     MPMediaPickerController* picker = [[MPMediaPickerController alloc] init];
     picker.delegate = self;
     picker.allowsPickingMultipleItems = NO; // this is the default 
     [self presentModalViewController:picker animated:YES];
}

- (void) mediaPicker: (MPMediaPickerController*) mediaPicker
   didPickMediaItems: (MPMediaItemCollection*) mediaItemCollection 
{
    MPMediaItem *mpItem = [[mediaItemCollection items] objectAtIndex: 0];
    NSURL *anUrl = [mpItem valueForProperty:MPMediaItemPropertyAssetURL];
    [self dismissModalViewControllerAnimated:YES];
    //audioPlayerMusic = [[AVPlayer alloc] initWithURL:anUrl];                      
    //[audioPlayerMusic play];
    //[self sampleTestStuff:anUrl ];
    [self playItemOverAudiUnit:mpItem];

}

- (void) mediaPickerDidCancel: (MPMediaPickerController*) mediaPicker {
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction) openMusicPicker:(id)sender
{
    [self presentPicker];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    hostMode = false;      
    //ohmFriend.text = [self getIPAddress];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Interface Actions

- (IBAction) startTraceClick:(id)sender
{
    NSString *userName = [NSString stringWithFormat:@"sip:%@@sipsorcery.com",fbField.text];
    init_pjpservices((char*)[codecNameTextField.text UTF8String], [clockRateTextField.text intValue]);
    
    if ([userName hasSuffix:@"sipsorcery.com"])
        pjsip_register((char*)[userName UTF8String],(char*) [fbField.text UTF8String]);
    else
        status = pjsua_start();
        
}

- (IBAction) callTraceClick:(id)sender
{
    NSString *callerName = [NSString stringWithFormat:@"sip:%@@sipsorcery.com",ohmFriend.text];
    const char *sip_uri = [callerName UTF8String];
    callSipAddress((char*) sip_uri);
}

- (IBAction) invokePlayFile:(id)sender 
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"03GoSlowly_MONO" ofType:@"wav"];
    NSLog(@"Path to wave file %@", path);
    invokePlayFile(path);
}

- (IBAction) linkPorts:(id)sender
{
    unsigned int sourcePortNum = [sourceNumberTextField.text intValue];
    unsigned int destinationPortNum = [destinationNumberTextField.text intValue]; 
    
    status = pjsua_conf_connect(sourcePortNum,destinationPortNum);
    
    if (status != PJ_SUCCESS)
		NSLog(@"Error linkPorts");
    
}

- (IBAction) unlinkPorts:(id)sender
{
    unsigned int sourcePortNum = [sourceNumberTextField.text intValue];
    unsigned int destinationPortNum = [destinationNumberTextField.text intValue]; 
    
    //status = pjmedia_conf_disconnect_port(pjm_conf,sourcePortNum, destinationPortNum);
    status = pjsua_conf_disconnect(sourcePortNum,destinationPortNum);
    if (status != PJ_SUCCESS)
		NSLog(@"Error linkPorts");
    
}

- (IBAction) showInfo:(id)sender 
{
   // conf_list(pjm_conf,1);
    pjusa_conf_list();
    

}

- (IBAction) dumpCurrentCallInfo:(id)sender 
{
    int sourcePortNum = [sourceNumberTextField.text intValue];
    log_call_dump(sourcePortNum);
}


- (NSString*) getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

- (void)playItemOverAudiUnit : (MPMediaItem* ) currentSong  
{
    static int total = 0;
    NSURL *currentSongURL = [currentSong valueForProperty:MPMediaItemPropertyAssetURL];
    NSLog(@"%@",currentSongURL);
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:currentSongURL options:nil];
    NSError *error = nil;    
    AVAssetReader* reader = [[AVAssetReader alloc] initWithAsset:songAsset error:&error];
    
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey, 
                                    [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                    [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    nil];
    
    
    //AVAssetReaderTrackOutput* readerOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track outputSettings:audioReadSettings];
    
    AVAssetReaderOutput *readerOutput =
                        [AVAssetReaderAudioMixOutput
                        assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                        audioSettings: outputSettings];
    
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
    
    static void * buffer = NULL;
    
    if(buffer != NULL)
    {
        free(buffer);
        buffer = NULL;
    }
    
    int buf_len = [mutableData length];
    buffer = malloc(buf_len);
    
    memcpy(buffer, [mutableData bytes], buf_len);

    //pj_pool_t * 	pool = pjsua_pool_create("pjsua-app-mem-pool", 1000000, 1000);
    pjmedia_port * sample_port;
    
    pj_status_t t = pjmedia_mem_player_create 	(pool, 
                                                 buffer, 
                                                 buf_len, 
                                                 44100/* 	clock_rate*/, 
                                                 1/* 	channel_count*/, 
                                                 88704, //* 	samples_per_frame*/, 
                                                 16 /*	bits_per_sample*/, 
                                                 1 /*	options*/, 
                                                 &sample_port);
    
    t = pjmedia_mem_player_set_eof_cb(sample_port, (void*)1234, &on_memplayer_complete);
    
    pjsua_conf_add_port (pool, sample_port, &mysong_port);
 
}

pj_status_t replaceCurrentMemPlayerWith(int trackSegmentID)
{

}

pj_status_t on_memplayer_complete(pjmedia_port *port, void *usr_data) 
{
    int idOfTrack = (int)usr_data;
    
    return 0;
}

- (void) sampleTestStuff : (NSURL*)currentSongURL
{
     int total = 0;
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:currentSongURL
                                                options:nil];
    NSError *error = nil;
    AVAssetReader* reader = [[AVAssetReader alloc]
                             initWithAsset:songAsset error:&error];    
    
    NSMutableDictionary* audioReadSettings = [NSMutableDictionary dictionary];
    [audioReadSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM]
                         forKey:AVFormatIDKey];
    
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey, 
                                    [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                    [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                    //  [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    nil];

    
    AVAssetReaderOutput *readerOutput = [AVAssetReaderAudioMixOutput
     assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
     audioSettings: outputSettings];
    
    
    [reader addOutput:readerOutput];
    [reader startReading];
    CMSampleBufferRef sample = [readerOutput copyNextSampleBuffer];
    
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
    
    invokePlayFile(newDir);
    
}
#pragma mark - PJSIP 

int invokePlayFile(NSString *filePath)
{
    /* Create file media port from the WAV file */
    status = pjmedia_wav_player_port_create(  pool,	/* memory pool	    */
                                            [filePath UTF8String],	/* file to play	    */
                                            20,	/* ptime.	    */
                                            0,	/* flags	    */
                                            0,	/* default buffer   */
                                            &file_port/* returned port    */
                                            );
    
    if (status != PJ_SUCCESS)
        return -1;
        
    pjsua_conf_add_port (pool, file_port, &mysong_port);
    PJ_ASSERT_RETURN(status == PJ_SUCCESS, 1);

    return 0;
}

/* Callback called by the library upon receiving incoming call */
void on_incoming_call(pjsua_acc_id acc_id, 
                      pjsua_call_id call_id,
                      pjsip_rx_data *rdata)
{
    pjsua_call_info ci;
    
    PJ_UNUSED_ARG(acc_id);
    PJ_UNUSED_ARG(rdata);
    
    pjsua_call_get_info(call_id, &ci);
    
    PJ_LOG(3,(THIS_FILE, "Incoming call from %.*s!!",
              (int)ci.remote_info.slen,
              ci.remote_info.ptr));
    
    hostMode = true;
    
    /* Automatically answer incoming calls with 200/OK */
    pjsua_call_answer(call_id, 200, NULL, NULL);
}
    

    


/* Callback called by the library when call's state has changed */
void on_call_state(pjsua_call_id call_id, 
                   pjsip_event *e)
{
    pjsua_call_info ci;
    
    PJ_UNUSED_ARG(e);
    
    pjsua_call_get_info(call_id, &ci);
    PJ_LOG(3,(THIS_FILE, "Call %d state=%.*s", call_id,
              (int)ci.state_text.slen,
              ci.state_text.ptr));
}

/* Callback called by the library when call's media state has changed */
void on_call_media_state(pjsua_call_id call_id)
{
    pjsua_call_info ci;
    _last_call_id = call_id; 
    pjsua_call_get_info(call_id, &ci);
    
    if (ci.media_status == PJSUA_CALL_MEDIA_ACTIVE) 
    {
        // When media is active, connect call to sound device.
        
        if (hostMode)
        {
            //pjsua_conf_connect(ci.conf_slot, mysong_port);
            pjsua_conf_connect(mysong_port, ci.conf_slot);
            pjsua_conf_connect(mysong_port, 0);
            pjsua_conf_adjust_rx_level(ci.conf_slot,0);
        }
        else
        {
            pjsua_conf_connect(ci.conf_slot, 0);
            pjsua_conf_connect(0, ci.conf_slot);
            pjsua_conf_adjust_tx_level(ci.conf_slot,0);
        }
    }
}

/* Display error and exit application */
void error_exit(const char *title, pj_status_t status)
{
    pjsua_perror(THIS_FILE, title, status);
    /* Start deinitialization: */
    
    /* Disconnect sound port from file port */
   // status = pjmedia_snd_port_disconnect(snd_port);
   // PJ_ASSERT_RETURN(status == PJ_SUCCESS, 1);
    
    /* Without this sleep, Windows/DirectSound will repeteadly
     * play the last frame during destroy.
     */
    pj_thread_sleep(100);
    
    /* Destroy sound device */
    if (snd_port != NULL) 
    {
        status = pjmedia_snd_port_destroy( snd_port );
        PJ_ASSERT_RETURN(status == PJ_SUCCESS, 1);
    }
    
    /* Destroy file port */
    if (file_port != NULL) 
    {
        status = pjmedia_port_destroy( file_port );
        PJ_ASSERT_RETURN(status == PJ_SUCCESS, 1);
    }
    
    /* Release application pool */
    if (pool!= NULL)
        pj_pool_release( pool );
    
    /* Destroy media endpoint. */
    if (med_endpt != NULL)
        pjmedia_endpt_destroy( med_endpt );
    
    /* Destroy pool factory */
    if (&cp != NULL)
        pj_caching_pool_destroy( &cp );
    
    /* Shutdown PJLIB */
    pj_shutdown();

    exit(1);
}

pj_status_t init_pjpservices(char* _lcodec, int _lclockrate ) 
{
    codec_id = _lcodec;
    DEFAULT_CLOCK_RATE = _lclockrate;
    /* Create pjsua first! */

    status = pjsua_create();
    PJ_ASSERT_RETURN(status == PJ_SUCCESS, 1);
    
    /* Init pjsua */
    {
        pjsua_config cfg;
        pjsua_logging_config log_cfg;
        
        pjsua_config_default(&cfg);
        
        pjsua_media_config_default(&pjsua_media_cfg);
        pjsua_media_cfg.clock_rate = DEFAULT_CLOCK_RATE;
        pjsua_media_cfg.snd_clock_rate = DEFAULT_CLOCK_RATE;
        pjsua_media_cfg.channel_count = 1;
        pjsua_media_cfg.enable_ice = PJ_TRUE;
        pjsua_media_cfg.ice_opt.aggressive = PJ_TRUE;
        pjsua_media_cfg.ec_tail_len = 0;
        pjsua_media_cfg.has_ioqueue = PJ_TRUE;
        pjsua_media_cfg.no_vad = PJ_TRUE;
        pjsua_media_cfg.snd_play_latency = (PJMEDIA_SND_DEFAULT_PLAY_LATENCY*2);
        
        cfg.cb.on_incoming_call = &on_incoming_call;
        cfg.cb.on_call_media_state = &on_call_media_state;
        cfg.cb.on_call_state = &on_call_state;
        cfg.stun_srv[0] = pj_str("stun.voipbuster.com");
        cfg.stun_srv[1] = pj_str("stun.sipgate.net:10000");
        cfg.stun_srv_cnt = 0;
        cfg.nat_type_in_sdp = 0;
    
        pjsua_logging_config_default(&log_cfg);
        log_cfg.console_level = 4;
        
        status = pjsua_init(&cfg, &log_cfg, NULL);
        if (status != PJ_SUCCESS) error_exit("Error in pjsua_init()", status);
        
    }
    
    /* Add Media Services */
    {
        /* Must create a pool factory before we can allocate any memory. */
        pj_caching_pool_init(&cp, &pj_pool_factory_default_policy, 64);
        
        /* 
         * Initialize media endpoint.
         * This will implicitly initialize PJMEDIA too.
         */
        
        status = pjmedia_endpt_create(&cp.factory, NULL, 1, &med_endpt);
        PJ_ASSERT_RETURN(status == PJ_SUCCESS, 1);
        
        /* Create memory pool for our file player */
        //pool = pj_pool_create( &cp.factory,	    /* pool factory	    */
        //                      "wav",	    /* pool name.	    */
        //                      4000,	    /* init size	    */
        //                      4000,	    /* increment size	    */
        //                      NULL		    /* callback on error    */
        //                      );
        
        pool = pjsua_pool_create("wav", 1024 * 8, 1024 * 8);
        
        int new_prio;
        char *codec=codec_id;
        char *prio="";
        pjsua_codec_info c[32];
        unsigned i, count = PJ_ARRAY_SIZE(c);
        new_prio = atoi(prio);
        pjsua_enum_codecs(c, &count);
        pj_str_t id;
        
        for (i=0; i<count; ++i) 
        {
            printf("  %d\t%.*s\n", c[i].priority, (int)c[i].codec_id.slen,
                   c[i].codec_id.ptr);
        }
        
        new_prio = PJMEDIA_CODEC_PRIO_HIGHEST;
        
        status = pjsua_codec_set_priority(pj_cstr(&id, codec), 
                                          (pj_uint8_t)new_prio);
        if (status != PJ_SUCCESS)
            pjsua_perror(THIS_FILE, "Error setting codec priority", status);

        if (status != PJ_SUCCESS)
            pjsua_perror(THIS_FILE, "Error setting codec priority", status);

    }
    
    /* Add UDP transport. */
    {
        pjsua_transport_config cfg;
        
        pjsua_transport_config_default(&cfg);
        cfg.port = 5060;
        status = pjsua_transport_create(PJSIP_TRANSPORT_UDP, &cfg, NULL);
        if (status != PJ_SUCCESS) error_exit("Error creating transport", status);
        
    }
    
}


pj_status_t pjsip_register(char* _sipURI, char* _name)
{
    SIP_USER = _name;
  
    /* Register to SIP server by creating SIP account. */
    {
        pjsua_acc_config cfg;
        
        pjsua_acc_config_default(&cfg);
        cfg.id = pj_str(_sipURI);
        cfg.reg_uri = pj_str("sip:" SIP_DOMAIN);
        cfg.cred_count = 1;
        cfg.cred_info[0].realm = pj_str(SIP_DOMAIN);
        cfg.cred_info[0].scheme = pj_str("digest");
        cfg.cred_info[0].username = pj_str(_name);
        cfg.cred_info[0].data_type = PJSIP_CRED_DATA_PLAIN_PASSWD;
        cfg.cred_info[0].data = pj_str(SIP_PASSWD);

        status = pjsua_acc_add(&cfg, PJ_TRUE, &acc_id);
        if (status != PJ_SUCCESS) error_exit("Error adding account", status);
    }
    
    /* Initialization is done, now start pjsua */
    status = pjsua_start();
    if (status != PJ_SUCCESS) error_exit("Error starting pjsua", status);
    return PJ_SUCCESS;
}

pj_status_t callSipAddress(char *sip_uri) 
{
    if (sip_uri != NULL) 
    {
        hostMode = false;
        pj_str_t uri = pj_str(sip_uri);
        status = pjsua_call_make_call(acc_id, &uri, 0, NULL, NULL, NULL);
        if (status != PJ_SUCCESS) error_exit("Error making call", status);
    }
    return PJ_SUCCESS;
}

pj_status_t  safeShutDown(void) 
{
    pjsua_destroy();
    return PJ_SUCCESS;
}

pj_status_t pjusa_conf_list(void)
{
    unsigned i, count;
    pjsua_conf_port_id id[PJSUA_MAX_CALLS];
    
    printf("Conference ports:\n");
    
    count = PJ_ARRAY_SIZE(id);
    pjsua_enum_conf_ports(id, &count);
    
    for (i=0; i<count; ++i) 
    {
        char txlist[PJSUA_MAX_CALLS*4+10];
        unsigned j;
        pjsua_conf_port_info info;
        
        pjsua_conf_get_port_info(id[i], &info);
        
        txlist[0] = '\0';
        for (j=0; j<info.listener_cnt; ++j) 
        {
            char s[10];
            pj_ansi_sprintf(s, "#%d ", info.listeners[j]);
            pj_ansi_strcat(txlist, s);
        }
        printf("Port #%02d[%2dKHz/%dms/%d] %20.*s  transmitting to: %s\n", 
               info.slot_id, 
               info.clock_rate/1000,
               info.samples_per_frame*1000/info.channel_count/info.clock_rate,
               info.channel_count,
               (int)info.name.slen, 
               info.name.ptr,
               txlist);
        
    }
    puts("");
}



void conf_list(pjmedia_conf *conf, int detail)
{
    enum { MAX_PORTS = 32 };
    unsigned i, count;
    pjmedia_conf_port_info info[MAX_PORTS];
    
    printf("Conference ports:\n");
    
    count = PJ_ARRAY_SIZE(info);
    pjmedia_conf_get_ports_info(conf, &count, info);
    
    for (i=0; i<count; ++i) 
    {
        char txlist[4*MAX_PORTS];
        unsigned j;
        pjmedia_conf_port_info *port_info = &info[i];	
        
        txlist[0] = '\0';
        for (j=0; j<port_info->listener_cnt; ++j) 
        {
            char s[10];
            pj_ansi_sprintf(s, "#%d ", port_info->listener_slots[j]);
            pj_ansi_strcat(txlist, s);
            
        }
        
        if (txlist[0] == '\0') 
        {
            txlist[0] = '-';
            txlist[1] = '\0';
        }
        
        if (!detail) 
        {
            printf("Port #%02d %-25.*s  transmitting to: %s\n", 
                   port_info->slot, 
                   (int)port_info->name.slen, 
                   port_info->name.ptr,
                   txlist);
        } 
        else 
        {
            unsigned tx_level, rx_level;
            
            pjmedia_conf_get_signal_level(conf, port_info->slot,
                                          &tx_level, &rx_level);
            
            printf("Port #%02d:\n"
                   "  Name                    : %.*s\n"
                   "  Sampling rate           : %d Hz\n"
                   "  Samples per frame       : %d\n"
                   "  Frame time              : %d ms\n"
                   "  Signal level adjustment : tx=%d, rx=%d\n"
                   "  Current signal level    : tx=%u, rx=%u\n"
                   "  Transmitting to ports   : %s\n\n",
                   port_info->slot,
                   (int)port_info->name.slen,
                   port_info->name.ptr,
                   port_info->clock_rate,
                   port_info->samples_per_frame,
                   port_info->samples_per_frame*1000/port_info->clock_rate,
                   port_info->tx_adj_level,
                   port_info->rx_adj_level,
                   tx_level,
                   rx_level,
                   txlist);
        }
        
    }
    puts("");
}

/*
 * Print log of call states. Since call states may be too long for logger,
 * printing it is a bit tricky, it should be printed part by part as long 
 * as the logger can accept.
 */
void log_call_dump(int call_id) 
{
    unsigned call_dump_len;
    unsigned part_len;
    unsigned part_idx;
    unsigned log_decor;
    
    pjsua_call_dump(call_id, PJ_TRUE, some_buf, 
                    sizeof(some_buf), "  ");
    call_dump_len = strlen(some_buf);
    
    log_decor = pj_log_get_decor();
    pj_log_set_decor(log_decor & ~(PJ_LOG_HAS_NEWLINE | PJ_LOG_HAS_CR));
    PJ_LOG(3,(THIS_FILE, "\n"));
    pj_log_set_decor(0);
    
    part_idx = 0;
    part_len = PJ_LOG_MAX_SIZE-80;
    while (part_idx < call_dump_len) {
        char p_orig, *p;
        
        p = &some_buf[part_idx];
        if (part_idx + part_len > call_dump_len)
            part_len = call_dump_len - part_idx;
        p_orig = p[part_len];
        p[part_len] = '\0';
        PJ_LOG(3,(THIS_FILE, "%s", p));
        p[part_len] = p_orig;
        part_idx += part_len;
    }
    pj_log_set_decor(log_decor);
}


@end
