//
//  LingooAppDelegate.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/3/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "DDHotKeyCenter.h"
#import "CRGoogleTranslate.h"

//////////////////////////////////////////////////////////////////////
// App delegate
//////////////////////////////////////////////////////////////////////
@interface LingooAppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow*			window;
	NSMenu*				statusMenu;
	NSPanel*			translatePanel;
	
	DDHotKeyCenter*		hotKeys;
	NSStatusItem*		statusItem;
	
	CRGoogleTranslate*	translate;
}

@property (assign) IBOutlet NSWindow*	window;
@property (assign) IBOutlet NSMenu*		statusMenu;
@property (assign) IBOutlet NSPanel*	translatePanel;

@property (assign) CRGoogleTranslate*	translate;

- (IBAction)showTranslator:(id)sender;

@end