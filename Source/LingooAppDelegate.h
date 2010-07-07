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
	DDHotKeyCenter*		hotKeys;
	NSStatusItem*		statusItem;
	
	CRGoogleTranslate*	translate;
	CRGoogleLanguage*	sourceLanguage;
	CRGoogleLanguage*	destinationLanguage;
	
@public
	NSMenu*				statusMenu;
	NSPanel*			translatePanel;
	NSTextField*		textSource;
	NSPopUpButton*		languagesButton;
}

@property (assign) IBOutlet NSMenu*			statusMenu;
@property (assign) IBOutlet NSPanel*		translatePanel;
@property (assign) IBOutlet NSTextField*	textSource;
@property (assign) IBOutlet NSPopUpButton*	languagesButton;

@property (readonly)	CRGoogleTranslate*	translate;
@property (assign)		CRGoogleLanguage*	sourceLanguage;
@property (assign)		CRGoogleLanguage*	destinationLanguage;

- (IBAction)showTranslator:(id)sender;
- (IBAction)translate:(id)sender;

@end