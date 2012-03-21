//
//  FilePaths.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "FilePaths.h"

@implementation FilePaths

#pragma mark Protected Methods

- (BOOL) createDirectoryAtPath:(NSString*)dirPath error:(NSError**)error
{
	NSParameterAssert([dirPath length]);
    
	if (![dirPath length]) return NO;
	
	NSFileManager* fm = [[NSFileManager alloc] init];
    
	const BOOL status = [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:error];
    
	return status;
}

- (BOOL) directoryExists:(NSString*)dirPath error:(NSError**)error
{
	NSParameterAssert([dirPath length]);
    
	return [self createDirectoryAtPath:dirPath error:error];
}

- (NSString*) documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return ([paths count]) ? [paths objectAtIndex:0] : nil;
}

#pragma mark Public Methods

- (NSString*) pathToPlaylistsDirectory:(NSError**)error
{
    static id cachedPlaylistDirectory = nil;
    
    if (cachedPlaylistDirectory) return cachedPlaylistDirectory;
    
    NSString* path = [self documentsDirectory];
    
    if (!path) return nil;
        
    if ([self directoryExists:path error:nil]
        || [self createDirectoryAtPath:path error:error])
    {
        cachedPlaylistDirectory = path;
    }
    
    return cachedPlaylistDirectory;
}

- (NSArray*) fullPathsToPlaylists
{        
    NSError* error = nil;
    
    NSString* playlistDirPath = [self pathToPlaylistsDirectory:&error];
    
    if (!playlistDirPath) return nil;
        
    NSFileManager* fm = [[NSFileManager alloc] init];
    
    NSArray* filenames = [fm contentsOfDirectoryAtPath:playlistDirPath error:&error];
    
    if (!filenames) return nil;
    
    NSMutableArray* fullPaths = [NSMutableArray arrayWithCapacity:[filenames count]];
    
    for (NSString* filename in filenames)
    {
        NSString* fullPath = [playlistDirPath stringByAppendingPathComponent:filename];
        
        if (fullPath)
        {
            [fullPaths addObject:fullPath];
        }
        
    }
    
    return fullPaths;
}

#pragma mark Object Lifetime

+ (FilePaths*) sharedInstance
{
	static id sharedInstance = nil;
	
    if (sharedInstance) return sharedInstance;
    
	@synchronized (self)
    {
        if (!sharedInstance)
        {
            sharedInstance = [[FilePaths alloc] init];
        }
    }
    
	return sharedInstance;
}

@end
