//
//  OhmPlaylistManager.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "OhmPlaylistManager.h"

#import "OhmTargetConditionals.h"
#import "DevicePersistentPlaylist.h"
#import "PersistentPlaylist.h"
#import "FilePaths.h"

@interface PersistentPlaylist ()

// Redefine the persistent playlist's name property to be writable inside the list manager...

@property (nonatomic, strong, readwrite) NSString *name;

@end

@implementation OhmPlaylistManager

#pragma mark Protected Methods

- (id) persistentPlaylistClass
{
#if !OHM_TARGET_SIMULATE
	return [DevicePersistentPlaylist class];
#else
	return [PersistentPlaylist class];
#endif
}

- (MutablePlaylist*) createQueue
{
    NSDictionary* dict = [PersistentPlaylist queueMemento];
	
	MutablePlaylist* ohmQueue =
	
	[[[self persistentPlaylistClass] alloc] initWithMemento:dict];
	
	return ohmQueue;
}

- (NSMutableArray*) loadPlaylists
{
    // Look in the file system for playlist property lists (i.e. serialized NSDictionary objects).
    // Then instantiate an PersistentPlaylist for each.
    
    NSArray* fullPathsToPlaylists = [[FilePaths sharedInstance] fullPathsToPlaylists];
    
    NSMutableArray* lists = [NSMutableArray array];
    
    for (NSString* fullPath in fullPathsToPlaylists)
    {
        NSDictionary* plist = [NSDictionary dictionaryWithContentsOfFile:fullPath];
        
		//NSLog(@"Reading playlist from : %@", fullPath);

        if (plist)
        {
            id playlist = [[[self persistentPlaylistClass] alloc] initWithMemento:plist];
            
            if (playlist)
            {				
				// If the playlist is the special queue, remember it but don't add it to
				// the list of non-queue playlists returned to callers; the queue is separate
				// from other playlists.
				
				if ([playlist isQueue])
				{
					queue = playlist;
				}
				else
				{
					[lists addObject:playlist];
				}
            }
        }
    }
	
	hasLoadedPlaylists = YES;

    return lists;
}

- (void) savePlaylists
{
	// Get the directory.
	// For each playlist, get its name and write it into the playlists directory...
	
	NSError* error = nil;
	
	NSString* path = [[FilePaths sharedInstance] pathToPlaylistsDirectory:&error];
	
	if (!path)
	{
		NSLog(@"%@", error);
		return;
	}
	
	NSArray* nonQueuePlaylists = [self persistentPlaylists];
	
	NSMutableArray* listsToSave = (nonQueuePlaylists) ? [NSMutableArray arrayWithArray:nonQueuePlaylists] : [NSMutableArray array];
	
	if (queue) [listsToSave addObject:queue];
	
	for (PersistentPlaylist* playlist in listsToSave)
	{		
		NSString* filename = [playlist filename];
		
		if (filename)
		{
			NSString* filePath = [path stringByAppendingPathComponent:filename];
			
			//NSLog(@"Writing playlist to : %@", filePath);

			if (filePath) [[playlist memento] writeToFile:filePath atomically:YES];
		}
	}
	
	
}

- (NSMutableArray*) playlists
{
    if (!playlists)
    {
        playlists = [self loadPlaylists];
    }
    
    return playlists;
}

#pragma mark Public Methods

- (MutablePlaylist*) queue
{
	if (!queue)
	{		
		// Loading the playlists has the side-effect of initializing the queue...
		
		if (!hasLoadedPlaylists)
		{
			[self playlists];
		}
		
		if (!queue)
		{
			// The playlists were loaded but no queue was found.
			// We need to initially create one.
			// Note: this should happen only once per app installation.
			
			queue = [self createQueue];
		
		}
		
	}
	
	return queue;
}

+ (MutablePlaylist*) queue
{
	return [[OhmPlaylistManager sharedInstance] queue];
}

- (NSArray*) persistentPlaylists
{
	// Note: the queue is NOT included in the returned result.
	
    return [self playlists]; // Don't let the caller know the result is mutable.
}

- (MutablePlaylist*) createEmptyPlaylistWithName:(NSString*)name
{
    NSParameterAssert([name length]);
    
    if (![name length]) return nil;
    
    id playlist = [[[self persistentPlaylistClass] alloc] initWithName:name];
    
    if (playlist) [[self playlists] addObject:playlist]; // Add to the list of all known playlists.
    
    return playlist;
}

- (MutablePlaylist*) copyPlaylist:(Playlist*)otherPlaylist withName:(NSString*)name
{    
    NSParameterAssert([name length]);
    
    if (![name length]) return nil;

    PersistentPlaylist* playlist = [[[self persistentPlaylistClass] alloc] initWithPlaylist:otherPlaylist];
    
    playlist.name = name;
    
    if (playlist) [[self playlists] addObject:playlist];  // Add to the list of all known playlists.

    return playlist;
}

#pragma mark Object Life Cycle

+ (id) sharedInstance
{
	static id sharedInstance = nil;
	
    if (sharedInstance) return sharedInstance;
    
	@synchronized (self)
    {
        if (!sharedInstance)
        {
            sharedInstance = [[OhmPlaylistManager alloc] init];
        }
    }

	return sharedInstance;
}

@end
