//
//  LingooAppDelegate.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/3/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LingooAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
