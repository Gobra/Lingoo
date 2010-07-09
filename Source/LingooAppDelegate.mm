//
//  LingooAppDelegate.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/3/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LingooAppDelegate.h"

//////////////////////////////////////////////////////////////////////
// App delegate
//////////////////////////////////////////////////////////////////////
@implementation LingooAppDelegate

@synthesize statusMenu;

+ (void)initialize
{
	if (self == [LingooAppDelegate class])
	{
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
		[statusItem setTitle:@"Lingoo"];
		[statusItem setHighlightMode:YES];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)awakeFromNib
{
	[statusItem setMenu:statusMenu];
}

//////////////////////////////////////////////////////////////////////
#pragma mark App delegate

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

- (LOTranslatorWindowController *)translatorController
{
	if (nil == translatorWindowController)
		translatorWindowController = [[LOTranslatorWindowController alloc] init];
	return translatorWindowController;
}

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
	[[self translatorController] fadeIn:nil];
}

- (IBAction)showTranslatorWithClipboard:(id)sender
{
	[[self translatorController] fadeIn:nil];
	[[self translatorController] readTextFromClipboard:self];
}

- (IBAction)showPreferences:(id)sender
{
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