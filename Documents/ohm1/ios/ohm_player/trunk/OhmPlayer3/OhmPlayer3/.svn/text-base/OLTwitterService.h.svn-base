//
//  OLTwitterService.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Post;

@interface OLTwitterService : NSObject

+ (OLTwitterService*) sharedInstance;

+ (BOOL) originatedPost:(Post*)post;

- (id) wireCellForPost:(Post*)post;

- (id) wireViewForPost:(Post*)post;

@property (nonatomic, strong) IBOutlet UIView* viewLoadPoint;

@end
