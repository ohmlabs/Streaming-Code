//
//  NotificationListener.m
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import "NotificationListener.h"

@implementation NotificationListener

#pragma mark Notification - Handlers

- (void) handleNotification:(NSNotification*)note
{
	// These pragma's suppress a clang warning when compiling for ARC.
	
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	[target performSelector:notificationHandler withObject:note];
#pragma clang diagnostic pop
}

#pragma mark Notification - Registration

- (void) registerForNotificationWithName:(NSString*)notificationName
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleNotification:)
												 name:notificationName
											   object:nil];
}

- (void) unregisterForNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id) initWithTarget:(id)aTarget notificationHandler:(SEL)aNotificationHandler notificationName:(NSString*)notificationName
{
	// Note: a nil target implies the first responder is the target.
	// Since the first responder is a valid target, we don't assert that aTarget must be non-nil.
	
	NSParameterAssert(aNotificationHandler);
	NSParameterAssert(notificationName);
	
    self = [super init];
    if (self) {
        target = aTarget;
		notificationHandler = aNotificationHandler;
		
		[self registerForNotificationWithName:notificationName];
	}
    return self;
}

- (id)init
{
    return [self initWithTarget:nil notificationHandler:nil notificationName:nil];
}

- (void)dealloc
{
    [self unregisterForNotifications];
}

@end
