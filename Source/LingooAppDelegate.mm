//
//  LingooAppDelegate.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/3/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LingooAppDelegate.h"
#import "CRChangeSignaler.h"
#import "CRDataToObjectTransformer.h"

//////////////////////////////////////////////////////////////////////
// App delegate
//////////////////////////////////////////////////////////////////////
@implementation LingooAppDelegate

@synthesize translator;
@synthesize languagePairs;
@synthesize statusMenu;

+ (void)initialize
{
	if (self == [LingooAppDelegate class])
	{
		[NSValueTransformer setValueTransformer:[CRDataToObjectTransformer transformer] forName:@"CRDataToObjectTransformer"];
		
		[LOPreferencesWindowController registerDefaults];
	}
}

- (id)init
{
	self = [super init];
	if (self)
	{
		// Status bar
		statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
		[statusItem setTitle:@""];
		[statusItem setImage:[NSImage imageNamed:@"Book"]];
		[statusItem setAlternateImage:[NSImage imageNamed:@"BookAlternate"]];
		[statusItem setHighlightMode:YES];
		
		// Google.Translate
		float reloadDelay = [[[NSUserDefaults standardUserDefaults] valueForKey:LOFailReloadDelayKey] floatValue];
		translator = [[CRGoogleTranslate alloc] init];
		[[translator jsExec] setReloadDelay:reloadDelay];
		CRChangeSignaler* signaler = [CRChangeSignaler signalWithObject:translator keyPath:@"isReady" target:self action:@selector(translateReady:)];
		[signaler retain];
		
		// Pairs
		languagePairs = [[CRGoogleLanguagePairsSet alloc] init];
		[languagePairs setAutosaveName:LOLanguagePairsKey];
		
		// Translator controller
		translatorWindowController = [[LOTranslatorWindowController alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[translator release];
	[languagePairs release];
	[translatorWindowController release];
	[super dealloc];
}

- (void)awakeFromNib
{
	[statusItem setMenu:statusMenu];
}

//////////////////////////////////////////////////////////////////////
#pragma mark App delegate

- (void)translateReady:(CRChangeSignaler *)signaler
{
	// we don't need signaler anymore
	[signaler release];
	
	// set pair up
	[languagePairs setTranslator:translator];
	[languagePairs readFromDefaults];
	
	// signal to everyone
	[[NSNotificationCenter defaultCenter] postNotificationName:LOTranslatorIsReadyNotification object:self];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// First run check
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	BOOL firstRun = [[ud valueForKey:LOFirstRunKey] boolValue];
	if (firstRun)
	{
		[self showPreferences:self];
		[ud setValue:[NSNumber numberWithBool:NO] forKey:LOFirstRunKey];
	}
	
	// Crash check
	[[FRFeedbackReporter sharedReporter] reportIfCrash];
	
	// Hotkeys
	[[LOHotKeysCenter sharedCenter] registerHotkeyForKey:LOShowTranslatorHotkeyKey withTarget:self action:@selector(showTranslator:)];
	[[LOHotKeysCenter sharedCenter] registerHotkeyForKey:LOShowTranslatorClipboardHotkeyKey withTarget:self action:@selector(showTranslatorWithClipboard:)];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (LOPreferencesWindowController *)preferencesController
{
	if (nil == preferencesWindowController)
		preferencesWindowController = [[LOPreferencesWindowController alloc] init];
	return preferencesWindowController;
}

- (CRAboutWindowController *)aboutController
{
	if (nil == aboutWindowController)
		aboutWindowController = [[CRAboutWindowController alloc] init];
	return aboutWindowController;
}

- (IBAction)showTranslator:(id)sender
{
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	
	[translatorWindowController fadeIn:nil];
}

- (IBAction)showTranslatorWithClipboard:(id)sender
{
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	
	[translatorWindowController fadeIn:nil];
	[translatorWindowController readTextFromClipboard:self];
}

- (IBAction)showPreferences:(id)sender
{
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	
	[[self preferencesController] show];
}

- (IBAction)showAbout:(id)sender
{
	[[self aboutController] show];
}

- (IBAction)sendFeedback:(id)sender
{
	[[FRFeedbackReporter sharedReporter] reportFeedback];
}

@end