//
//  LingooAppDelegate.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/3/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LOPreferencesWindowController.h"
#import "LOTranslatorWindowController.h"
#import "CRAboutWindowController.h"

//////////////////////////////////////////////////////////////////////
// App delegate
//////////////////////////////////////////////////////////////////////
@interface LingooAppDelegate : NSObject <NSApplicationDelegate>
{
@private
	NSStatusItem*					statusItem;
	CRGoogleTranslate*				translator;
	CRGoogleLanguagePairsSet*		languagePairs;
	
@private
	LOPreferencesWindowController*	preferencesWindowController;
	LOTranslatorWindowController*	translatorWindowController;
	CRAboutWindowController*		aboutWindowController;
	
@public
	NSMenu*							statusMenu;
}

@property (readonly) CRGoogleTranslate*			translator;
@property (readonly) CRGoogleLanguagePairsSet*	languagePairs;
@property (assign) IBOutlet NSMenu*				statusMenu;

- (IBAction)showTranslator:(id)sender;
- (IBAction)showTranslatorWithClipboard:(id)sender;
- (IBAction)showPreferences:(id)sender;
- (IBAction)sendFeedback:(id)sender;
- (IBAction)showAbout:(id)sender;

@end