//
//  PersistentPlaylist.m
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "PersistentPlaylist.h"

#import "MusicLibrary.h"

static NSString* const KEY_NAME     = @"KEY_NAME";
static NSString* const KEY_SONG_IDS = @"KEY_SONG_IDS";
static NSString* const KEY_IS_QUEUE = @"KEY_IS_QUEUE";
static NSString* const KEY_FILENAME	= @"KEY_FILENAME";

@implementation PersistentPlaylist

- (NSString*) name
{
	return [state valueForKey:KEY_NAME];
}

- (BOOL) isQueue
{
	return [[state valueForKey:KEY_IS_QUEUE] boolValue];
}

- (NSString*) filename
{
	return [state valueForKey:KEY_FILENAME];
}

+ (NSMutableDictionary*) mementoWithName:(NSString*)name songIDs:(NSArray*)songObjs
{
    NSParameterAssert(name);
	
	if (![name length]) return nil;
	
	NSMutableDictionary* dict	= [NSMutableDictionary dictionary];
	NSMutableArray* songs		= (songObjs) ? [songObjs mutableCopy] : [NSMutableArray array];
	
    [dict setValue:name forKey:KEY_NAME];
    [dict setValue:songs forKey:KEY_SONG_IDS];
	
	return dict;
}

+ (NSMutableDictionary*) mementoWithName:(NSString*)name
{
	return [PersistentPlaylist mementoWithName:name songIDs:nil];
}

+ (NSDictionary*) queueMemento
{
	NSString* name = NSLocalizedString(@"Queue", @"Queue");
	
	NSMutableDictionary* dict = [PersistentPlaylist mementoWithName:name];
	
	[dict setValue:[NSNumber numberWithBool:YES] forKey:KEY_IS_QUEUE];
	[dict setValue:@"Queue" forKey:KEY_FILENAME];
	
	return dict;
}

- (NSDictionary*) memento
{
	[state setValue:self.songIDs forKey:KEY_SONG_IDS];
	
	return state;
}

- (NSString*) uniqueID
{
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	
	CFStringRef s = CFUUIDCreateString(NULL, uuid);

	CFRelease(uuid);

	NSString* result = [NSString stringWithString:(__bridge NSString*)s];
	
	CFRelease(s);
	
	return result;
}

- (MusicLibrary*) musicLibrary
{
	return musicLibrary();
}

- (id) initWithMemento:(NSDictionary*)memento
{
    state = [memento mutableCopy];
	
	NSString* playlistName = [state valueForKey:KEY_NAME];
	 
    NSParameterAssert(playlistName);
    
    if (!playlistName)
    {
        return nil;
    }
    
	// If the memento already has a persistent filename, use it.
	// Otherwise, we assign one.
	if (![[state valueForKey:KEY_FILENAME] length])
	{
		[state setValue:[self uniqueID] forKey:KEY_FILENAME];
	}
	
    self = [super initWithName:playlistName];
    if (self) {
        
        // We need to turn the playlist song IDs into song objects if we can.
		
		NSArray* IDs = [state valueForKey:KEY_SONG_IDS];
		
		for (NSNumber* identifier in IDs)
		{
			Song* song = [[self musicLibrary] songForSongID:identifier];
			
			if (song)
			{
				[self addSong:song];
			}
			
		}
		
    }
    
    return self;
}

- (id) initWithPlaylist:(Playlist*)otherPlaylist
{
    NSMutableDictionary* dict = [PersistentPlaylist mementoWithName:otherPlaylist.name songIDs:otherPlaylist.songIDs];
    
	// Note: when we create a new playlist from a queue, the new playlist does NOT inherit the queue property.
	
    return [self initWithMemento:dict];
}

- (id) initWithName:(NSString*)newName
{
    NSDictionary* dict = [PersistentPlaylist mementoWithName:newName];

    return [self initWithMemento:dict];
}

- (id)init
{
    return [self initWithMemento:nil];
}

@end
