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
@synthesize translatePanel;
@synthesize textSource;
@synthesize languagesButton;

@synthesize translate;
@synthesize selectedSourceLanguage;

- (id)init
{
	self = [super init];
	if (self)
	{
		// Global hot keys
		hotKeys = [[DDHotKeyCenter alloc] init];
		
		// Status bar
		statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
		[statusItem setTitle:@"Lingoo"];
		[statusItem setHighlightMode:YES];
		
		// Google.Translate
		translate = [[CRGoogleTranslate alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[hotKeys release];
	[translate release];
	[super dealloc];
}

- (void)awakeFromNib
{
	[statusItem setMenu:statusMenu];
	
	[self showTranslator:self];
	
	NSView* view = [[translate jsExec] view];
	[view setFrame:NSMakeRect(7, 10, 255, 220)];
	[[[self translatePanel] contentView] addSubview:view];
}

//////////////////////////////////////////////////////////////////////
#pragma mark App delegate

- (void)applicationWillTerminate:(NSNotification *)notification
{
	[hotKeys unregisterHotKeysWithTarget:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[hotKeys registerHotKeyWithKeyCode:11 modifierFlags:(NSShiftKeyMask | NSCommandKeyMask) target:self action:@selector(toggleTranslator:) object:nil];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Queries

- (void)detectionComplete:(CRJSRemoteQuery *)query
{
	if ([query successStatus])
	{
		[self setSelectedSourceLanguage:[translate languageFromQuery:query]];
	}
}

//////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (void)showTranslator:(id)sender
{
	[translatePanel makeKeyAndOrderFront:self];
}

- (void)translate:(id)sender
{
	NSDictionary* params = [NSDictionary dictionaryWithObject:[textSource stringValue] forKey:CRGoogleTranslateTextKey];
	[translate detectLanguage:[CRJSRemoteQuery queryWithTarget:self action:@selector(detectionComplete:) params:params]];
}

@end