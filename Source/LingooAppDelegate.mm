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
		// Global hot keys
		hotKeys = [[DDHotKeyCenter alloc] init];
		[hotKeys registerHotKeyWithKeyCode:11 modifierFlags:(NSShiftKeyMask | NSCommandKeyMask) target:self action:@selector(toggleTranslator:) object:nil];
		
		// Status bar
		statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
		[statusItem setTitle:@"Lingoo"];
		[statusItem setHighlightMode:YES];
	}
	return self;
}

- (void)dealloc
{
	[hotKeys release];
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
	[hotKeys unregisterHotKeysWithTarget:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// First run check
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	BOOL firstRun = [[ud valueForKey:LOFirstRunKey] boolValue];
	if (firstRun)
	{
		[self showPreferences:self];
		
		//[ud setValue:[NSNumber numberWithBool:NO] forKey:LOFirstRunKey];
	}
	
	// Crash check
	[[FRFeedbackReporter sharedReporter] reportIfCrash];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (LOTranslatorWindowController *)translatorController
{
	if (nil == translatorWindowController)
		translatorWindowController = [[LOTranslatorWindowController alloc] init];
	return translatorWindowController;
}

- (LOPreferencesWindowController *)preferncesController
{
	if (nil == preferencesWindowController)
		preferencesWindowController = [[LOPreferencesWindowController alloc] init];
	return preferencesWindowController;
}

- (IBAction)showTranslator:(id)sender
{
	[[self translatorController] fadeIn:nil];
}

- (IBAction)showPreferences:(id)sender
{
	[[self preferncesController] showWindow:self];
}

- (IBAction)sendFeedback:(id)sender
{
	[[FRFeedbackReporter sharedReporter] reportFeedback];
}

@end