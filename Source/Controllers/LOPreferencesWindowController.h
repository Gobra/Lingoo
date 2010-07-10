//
//  LOPreferencesWindowController.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

@class CRAutorunOnLogin;

//////////////////////////////////////////////////////////////////////
// Preferences window controller
//////////////////////////////////////////////////////////////////////
@interface LOPreferencesWindowController : NSWindowController
{
	CRAutorunOnLogin*			autoRun;
	
@public
	IBOutlet SRRecorderControl*	hotKeyShow;
	IBOutlet SRRecorderControl*	hotKeyShowClipboard;
	
	IBOutlet NSPanel*			languagePairsSheet;
	IBOutlet NSPopUpButton*		sourceLanguageButton;
	IBOutlet NSPopUpButton*		destinationLanguageButton;
	IBOutlet NSArrayController*	languagePairsController;
}

@property (readonly) CRAutorunOnLogin*	autoRun;

+ (void)registerDefaults;
- (void)show;

- (void)addNewLanguagePair:(id)sender;
- (void)cancelNewLanguagePair:(id)sender;
- (void)acceptNewLanguagePair:(id)sender;
- (void)removeSelectedPairs:(id)sender;

@end