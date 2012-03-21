//
//  SongsTableViewDataSource.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongsTableViewDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>
{
	NSArray* songs;
}

@property (nonatomic, strong, readonly) NSArray* allSongs;

@end
