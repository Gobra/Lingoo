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
	CRGoogleLanguage*	sourceLanguage;
	CRGoogleLanguage*	destinationLanguage;
	
@private
	NSSize				originalSize;
	
@public
	NSTextField*		textSource;
}

@property (assign) CRGoogleLanguage*		sourceLanguage;			// Source language object
@property (assign) CRGoogleLanguage*		destinationLanguage;	// Destination language object

@property (assign) IBOutlet NSTextField*	textSource;				// Text-to-translate source control

+ (id)controller;

- (NSSize)originalSize;
- (BOOL)autoselectTranslated;
- (BOOL)autotranslateForClipboard;
- (BOOL)autoclipboardTranslated;

- (IBAction)saveDefaults:(id)sender;
- (IBAction)loadDefaults:(id)sender;
- (IBAction)readTextFromClipboard:(id)sender;
- (IBAction)translate:(id)sender;

@end