//
//  AlbumsTableViewDataSource.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumsTableViewDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>
{
	NSArray* albums;
	
	NSMutableDictionary* imageCache;
	
}

@end
