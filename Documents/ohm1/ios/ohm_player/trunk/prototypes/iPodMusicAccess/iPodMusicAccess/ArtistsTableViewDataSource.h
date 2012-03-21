//
//  ArtistsTableViewDataSource.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtistsTableViewDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>
{
	NSArray* artists;
}

@property (nonatomic, strong, readonly) NSArray* allArtists;

@end
