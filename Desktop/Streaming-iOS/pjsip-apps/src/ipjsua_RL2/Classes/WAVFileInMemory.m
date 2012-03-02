//
//  WAVFileInMemory.m
//  ipjsua
//
//  Created by Dmitry Bichan on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WAVFileInMemory.h"



@implementation WAVFileInMemory
@synthesize fileData = _fileData;
@synthesize wavheader = _wavheader;

- (id) init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

- (id) initFithFileURL:(NSURL *)url
{
    self = [super init];
    if(self != nil)
    {
        _wavheader = [self open:url];
    }
    return self;
}

- (struct WAVHEADER) open:(NSURL *)url
{
    struct WAVHEADER  wavheader;
    memset(&wavheader, 0, sizeof(wavheader));
    
    NSAutoreleasePool * releasePool = [[NSAutoreleasePool alloc] init];
    
    NSData * wavFileData = [NSData dataWithContentsOfURL:url];
    
    if (wavFileData != nil) 
    {
        memcpy(&wavheader, [wavFileData bytes], sizeof(wavheader));
        
        // Выводим полученные данные
        NSLog(@"Sample rate: %lu\n", wavheader.sampleRate);
        NSLog(@"Channels: %d\n", wavheader.numChannels);
        NSLog(@"Bits per sample: %d\n", wavheader.bitsPerSample);
        
        [_fileData release];
        _fileData = [[NSData alloc] initWithBytes: ((char*)[wavFileData bytes] +sizeof(wavheader))  
                                           length:[wavFileData length] - sizeof(wavheader)];
    }
    
    [releasePool release];
    
    return wavheader;
}

- (void) dealloc
{
    [_fileData release];
    
    [super dealloc];
}

@end
