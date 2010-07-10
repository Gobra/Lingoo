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
	id langPairsData = [CRGoogleLanguagePairsSet defaultData];								// default data
	
	// defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithBool:YES],				LOFirstRunKey,
	  [NSNumber numberWithInt:0],					LOTranslatorTypeIndexKey,
	  [NSNumber numberWithBool:YES],				LOAutodetectLanguageKey,
	  @"en",										LOSourceLanguageCodeKey,
	  @"en",										LODestinationLanguageCodeKey,
	  [NSNumber numberWithBool:YES],				LOAutoselectTranslationKey,
	  [NSNumber numberWithBool:YES],				LOUseLanguagePairsKey,
	  [NSNumber numberWithBool:YES],				LOAutotranslateFromClipboardKey,
	  [NSNumber numberWithBool:NO],					LOAutoclipboardTranslationKey,
	  
	  langPairsData,								LOLanguagePairsKey,
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
	self = [super initWithWindowNibName:@"PreferencesWindow"];
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

- (void)show
{
	[self showWindow:self];
	[[self window] orderFront:self];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Language paris

- (void)addNewLanguagePair:(id)sender
{
	[sourceLanguageButton selectItemAtIndex:0];
	[destinationLanguageButton selectItemAtIndex:0];
	
	[NSApp beginSheet:languagePairsSheet
	   modalForWindow:[self window]
        modalDelegate:nil
       didEndSelector:NULL
          contextInfo:NULL];
}

- (IBAction)cancelNewLanguagePair:(id)sender
{
	[NSApp endSheet:languagePairsSheet];
	[languagePairsSheet orderOut:sender];
}

- (IBAction)acceptNewLanguagePair:(id)sender
{
	// add new record
	CRGoogleLanguage* sourceCode = [[sourceLanguageButton selectedItem] representedObject];
	CRGoogleLanguage* destinationCode = [[destinationLanguageButton selectedItem] representedObject];
	[[LOShared languagePairs] addDestination:destinationCode forSource:sourceCode];
	
	// remove the sheet
	[NSApp endSheet:languagePairsSheet];
	[languagePairsSheet orderOut:sender];
}

- (void)removeSelectedPairs:(id)sender
{
	NSArray* items = [languagePairsController selectedObjects];
	
	if ([items count] > 0)
	{
		// texts
		NSString* confirmation	= NSLocalizedString(@"common.confirmation", @"");
		NSString* erase			= NSLocalizedString(@"common.erase", @"");
		NSString* cancel		= NSLocalizedString(@"common.cancel", @"");
		NSString* question		= NSLocalizedString(@"common.confirm_erase", @"");
		
		NSString* message = [NSString stringWithFormat:question, [items count]];
		if (NSAlertAlternateReturn != NSRunAlertPanel(confirmation, message, erase, cancel, nil))
		{
			for (CRGoogleLanguagePair* pair in items)
				[[LOShared languagePairs] removePair:pair];
		}
	}
}

@end