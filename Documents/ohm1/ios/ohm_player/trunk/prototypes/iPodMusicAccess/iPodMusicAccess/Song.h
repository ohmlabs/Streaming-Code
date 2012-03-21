//
//  Song.h
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class represents a song.

@interface Song : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *artistName;
@property (nonatomic, strong, readonly) NSString *albumName;

- (id) initWithTitle:(NSString*)title artist:(NSString*)artist album:(NSString*)album; // Designated initializer.

@end
