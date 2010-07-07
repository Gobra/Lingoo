//
//  LingooAppDelegate.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/3/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "DDHotKeyCenter.h"
#import "LOPreferencesWindowController.h"
#import "LOTranslatorWindowController.h"

//////////////////////////////////////////////////////////////////////
// App delegate
//////////////////////////////////////////////////////////////////////
@interface LingooAppDelegate : NSObject <NSApplicationDelegate>
{	
	DDHotKeyCenter*					hotKeys;
	NSStatusItem*					statusItem;
	LOPreferencesWindowController*	preferencesWindowController;
	LOTranslatorWindowController*	translatorWindowController;
	
@public
	NSMenu*							statusMenu;
}

@property (assign) IBOutlet NSMenu*	statusMenu;

- (IBAction)showTranslator:(id)sender;
- (IBAction)showPreferences:(id)sender;
- (IBAction)sendFeedback:(id)sender;

@end