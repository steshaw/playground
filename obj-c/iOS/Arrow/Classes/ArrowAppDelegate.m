//
//  ArrowAppDelegate.m
//  Arrow
//
//  Created by Steven Shaw on 24/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ArrowAppDelegate.h"
#import "EAGLView.h"

@implementation ArrowAppDelegate

@synthesize window;
@synthesize glView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions   
{
    [glView startAnimation];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [glView stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [glView stopAnimation];
}

- (void)dealloc
{
    [window release];
    [glView release];

    [super dealloc];
}

@end
