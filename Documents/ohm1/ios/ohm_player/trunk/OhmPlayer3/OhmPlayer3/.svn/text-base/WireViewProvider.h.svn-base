//
//  WireViewProvider.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@interface WireViewProvider : NSObject

@property (strong, nonatomic) Person* person;

- (NSUInteger) numberOfColumnsInWire;

- (UIView*) wireViewForColumnAtIndex:(NSUInteger)index;

- (UIView*) wireCellForColumnAtIndex:(NSUInteger)index;

- (id) initWithPerson:(Person*)person; // Designated initializer.

- (id) init;

@end
