//
//  LOTranslatorController.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRGoogleTranslate.h"

extern NSString* const LODeferredTranslateRequestKey;

//////////////////////////////////////////////////////////////////////
// Translator controller
//////////////////////////////////////////////////////////////////////
@interface LOTranslatorController : NSViewController
{
	CRGoogleLanguage*		sourceLanguage;
	CRGoogleLanguage*		destinationLanguage;
	
@private
	BOOL					ignoreAction;			// signal whether text field action should be ignored
	NSSize					originalSize;
	
@private
	NSTextField*			textSource;
	BWTransparentButton*	swapButton;
}

@property (assign) CRGoogleLanguage*				sourceLanguage;			// Source language object
@property (assign) CRGoogleLanguage*				destinationLanguage;	// Destination language object

@property (assign) IBOutlet NSTextField*			textSource;				// Text-to-translate source control
@property (assign) IBOutlet BWTransparentButton*	swapButton;				// Swap languages button

+ (id)controller;
+ (NSSize)defaultSize;
- (NSSize)defaultSize;

- (BOOL)autoselectTranslated;
- (BOOL)autotranslateForClipboard;
- (BOOL)autoclipboardTranslated;
- (BOOL)canScaleVertically;

- (void)activate;
- (void)loadSizeFromDefaults;
- (void)saveSizeToDefaults;

- (IBAction)swapLanguages:(id)sender;
- (IBAction)saveLanguageDefaults:(id)sender;
- (IBAction)loadLanguageDefaults:(id)sender;
- (IBAction)readTextFromClipboard:(id)sender;
- (IBAction)translate:(id)sender;

@end