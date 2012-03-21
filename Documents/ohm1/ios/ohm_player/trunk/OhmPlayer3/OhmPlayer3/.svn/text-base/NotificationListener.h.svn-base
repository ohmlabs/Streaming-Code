//
//  NotificationListener.h
//  OhmPlayer3
//
//  Copyright (c) 2011 Ohm Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

// NotificationListener objects register for their argument notification at init time
// and unregisater themselves when their no longer referenced.

// When the notification is oberved, the action method is called on the target.

@interface NotificationListener : NSObject
{
	id target;
	SEL notificationHandler;
}

- (id) initWithTarget:(id)aTarget notificationHandler:(SEL)aNotificationHandler notificationName:(NSString*)notificationName; // Designated initializer.

@end
