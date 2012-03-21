//
//  InstagramAPI.m
//  InstaMemory
//
//  Created by Ivica Aracic on 08.08.11.
//  Copyright 2011 Ivica Aracic. All rights reserved.
//

 
#import "InstagramAPI.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "NSString+SBJSON.h"

//=========================
// CLIENT SPECIFIC CONFIG

#define kAppId @"0ac3eead6aa14901b5adcdcc7da83bce"
#define kAppSecret @"15f11724d2b9468095d45d8f8538a627"
#define RESPONSE_URL (@"ohm//authorize")

// API CACHE
#define REQUEST_CACHE_INTERVAL_SEC 60       // in s

// IMAGE CACHE
#define CACHE_MAX_SIZE (8*1024*1024)   // 8MB
#define DOWNLOAD_QUEUE_MAX_CONCURRENT_OPS 3

#define API_SCOPE @"likes+comments+relationships"

//==========================

#define ACCESS_TOKEN_KEY            @"instagram-accessToken"
#define ACCESS_LOGGED_USER_JSON     @"instagram-logged-user-json"

#define BASE_URL @"https://api.instagram.com/v1"


NSString* ACTION_IMG_DOWNLOAD = @"ACTION_IMG_DOWNLOAD";
NSString* ACTION_GET_USER_MEDIA_RECENT = @"ACTION_GET_USER_MEDIA_RECENT";
NSString* ACTION_GET_USER_MEDIA_LIKED = @"ACTION_GET_USER_MEDIA_LIKED";
NSString* ACTION_GET_USER_FEED = @"ACTION_GET_USER_FEED";
NSString* ACTION_GET_MEDIA_POPULAR = @"ACTION_GET_MEDIA_POPULAR";
NSString* ACTION_GET_TAG_MEDIA_RECENT = @"ACTION_GET_TAG_MEDIA_RECENT";
NSString* ACTION_POST_MEDIA_LIKE = @"ACTION_POST_MEDIA_LIKE";
NSString* ACTION_DELETE_MEDIA_LIKE = @"ACTION_DELETE_MEDIA_LIKE";
NSString* ACTION_GET_USER_SELF = @"ACTION_GET_USER_SELF";
NSString* ACTION_POST_USERS_FOLLOW = @"ACTION_POST_USERS_FOLLOW";
NSString* ACTION_GET_USERS_SEARCH = @"ACTION_GET_USERS_SEARCH";


static NSString* USER_INFO_KEY_ACTION = @"action";
static NSString* USER_INFO_KEY_IMG_ID = @"imgId";
static NSString* USER_INFO_KEY_USER_INFO = @"userInfo";

//==========================

@interface InstagramCacheItem : NSObject {
    NSString* filename;
    NSDictionary* attributes;
}

@property (nonatomic, retain) NSString* filename;
@property (nonatomic, retain) NSDictionary* attributes;
@property (nonatomic, readonly) NSNumber* fileSize;
@property (nonatomic, readonly) NSDate* modificationDate;

- (id) initWithFilename:(NSString*)_filename withAttributes:(NSDictionary*)attrs;

@end
// ---------------------------
@implementation InstagramCacheItem 
@synthesize filename, attributes;

- (id) initWithFilename:(NSString*)_filename withAttributes:(NSDictionary*)attrs {
    if((self = [super init])) {
        self.filename = _filename;
        self.attributes = attrs;
    }
    
    return self;
}


- (NSNumber*) fileSize {
    return [attributes objectForKey:NSFileSize];   
}

- (NSDate*) modificationDate {
    return [attributes objectForKey:NSFileModificationDate];   
}

@end

//==========================

@interface ApiRequestCacheItem : NSObject {
    NSDate* timestamp;
    id obj;
}

@property (readonly, nonatomic) BOOL valid;
@property (readonly, nonatomic) NSDate* timestamp;
@property (readonly, nonatomic) id obj;

@end
// ---------------------------


