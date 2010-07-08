//
//  LingooAppDelegate.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/3/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LOPreferencesWindowController.h"
#import "LOTranslatorWindowController.h"
#import "LOAboutWindowController.h"

//////////////////////////////////////////////////////////////////////
// App delegate
//////////////////////////////////////////////////////////////////////
@interface LingooAppDelegate : NSObject <NSApplicationDelegate>
{	
	NSStatusItem*					statusItem;
	LOPreferencesWindowController*	preferencesWindowController;
	LOTranslatorWindowController*	translatorWindowController;
	LOAboutWindowController*		aboutWindowController;
	
@public
	NSMenu*							statusMenu;
}

@property (assign) IBOutlet NSMenu*	statusMenu;

- (IBAction)showTranslator:(id)sender;
- (IBAction)showTranslatorWithClipboard:(id)sender;
- (IBAction)showPreferences:(id)sender;
- (IBAction)sendFeedback:(id)sender;
- (IBAction)showAbout:(id)sender;

@end