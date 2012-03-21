//
//  Artist.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class represents an artist.

@interface Artist : NSObject
{
@private
	
	NSMutableArray* albums;
	NSMutableArray* songs;
}

@property (nonatomic, strong, readonly) NSString *name;

@property (nonatomic, strong, readonly) NSArray *albums;	// All Album for objects this artist
@property (nonatomic, strong, readonly) NSArray *songs;		// All Song objects for this artist

- (id) initWithName:(NSString*)name; // Designated initializer.

@end
