//
//  neheAppDelegate.h
//  nehe
//
//  Created by Steven Shaw on 27/04/11.
//  Copyright 2011 Code Fu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface neheAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
