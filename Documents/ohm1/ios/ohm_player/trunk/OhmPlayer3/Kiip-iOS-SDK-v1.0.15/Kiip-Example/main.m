//
//  main.m
//  Kiip Example
//
//  Created by Grantland Chew on 2/21/11.
//  Copyright 2011 Kiip, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainAppDelegate.h"

int main(int argc, char *argv[]) {

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([MainAppDelegate class]));
    [pool release];
    return retVal;
}
