//
//  LOPreferencesWindowController.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LOPreferencesWindowController.h"
#import "CRAutorunOnLogin.h"
#import "SGKeyCombo.h"

//////////////////////////////////////////////////////////////////////
// Preferences window controller
//////////////////////////////////////////////////////////////////////
@implementation LOPreferencesWindowController

@synthesize autoRun;

+ (void)registerDefaults
{
	// prepapre
	SGKeyCombo* comboShow = [[SGKeyCombo alloc] initWithKeyCode:37 modifiers:2304];			// cmd + alt + L
	SGKeyCombo* comboShowClipboard = [[SGKeyCombo alloc] initWithKeyCode:8 modifiers:2304];	// cmd + alt + C
	
	// defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithBool:YES],				LOFirstRunKey,
	  [NSNumber numberWithInt:0],					LOTranslatorTypeIndexKey,
	  [NSNumber numberWithBool:YES],				LOAutodetectLanguageKey,
	  @"en",										LOSourceLanguageCodeKey,
	  @"en",										LODestinationLanguageCodeKey,
	  [NSNumber numberWithBool:YES],				LOAutoselectTranslationKey,
	  [NSNumber numberWithBool:YES],				LOAutotranslateFromClipboardKey,
	  [NSNumber numberWithBool:NO],					LOAutoclipboardTranslationKey,
	  
	  [comboShow plistRepresentation],				LOShowTranslatorHotkeyKey,
	  [comboShowClipboard plistRepresentation],		LOShowTranslatorClipboardHotkeyKey,
	  nil]
	 ];
	
	// cleanup
	[comboShow release];
	[comboShowClipboard release];
}

- (id)init
{
	self = [super initWithWindowNibName:@"Preferences"];
	if (self)
	{
		NSURL* appURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
		autoRun = [[CRAutorunOnLogin alloc] initWithURL:appURL];
	}
	return self;
}

- (void)dealloc
{
	[autoRun release];
	[super dealloc];
}

- (void)awakeFromNib
{
	[hotKeyShow setDelegate:self];
	[hotKeyShowClipboard setDelegate:self];
	
	// Default hotkeys
	[hotKeyShow setKeyCombo:[[LOHotKeysCenter sharedCenter] controlComboForKey:LOShowTranslatorHotkeyKey]];
	[hotKeyShowClipboard setKeyCombo:[[LOHotKeysCenter sharedCenter] controlComboForKey:LOShowTranslatorClipboardHotkeyKey]];
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo
{
	if (aRecorder == hotKeyShow)
		[[LOHotKeysCenter sharedCenter] saveControlCombo:[aRecorder keyCombo] forKey:LOShowTranslatorHotkeyKey];
	else if (aRecorder == hotKeyShowClipboard)
		[[LOHotKeysCenter sharedCenter] saveControlCombo:[aRecorder keyCombo] forKey:LOShowTranslatorClipboardHotkeyKey];
}

@end