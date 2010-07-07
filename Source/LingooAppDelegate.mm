//
//  LingooAppDelegate.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/3/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LingooAppDelegate.h"
#import "CRChangeSignaler.h"

NSString* const LODeferredTranslateRequestKey = @"LODeferredTranslateRequestKey";

//////////////////////////////////////////////////////////////////////
// App delegate
//////////////////////////////////////////////////////////////////////
@implementation LingooAppDelegate

@synthesize statusMenu;
@synthesize translatePanel;
@synthesize textSource;
@synthesize languagesButton;

@synthesize translate;
@synthesize sourceLanguage;
@synthesize destinationLanguage;

+ (void)initialize
{
	// Defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithBool:YES],	LOAutodetectLanguageKey,
	  @"en",							LOSourceLanguageCodeKey,
	  @"en",							LODestinationLanguageCodeKey,
	  nil]
	 ];
}

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
		CRChangeSignaler* signaler = [CRChangeSignaler signalWithObject:translate keyPath:@"isReady" target:self action:@selector(translateReady:)];
		[signaler retain];
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
}

//////////////////////////////////////////////////////////////////////
#pragma mark App delegate

- (void)applicationWillTerminate:(NSNotification *)notification
{
	[hotKeys unregisterHotKeysWithTarget:self];
	
	// Save some defaults
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	[ud setValue:[[self sourceLanguage] languageCode] forKey:LOSourceLanguageCodeKey];
	[ud setValue:[[self destinationLanguage] languageCode] forKey:LODestinationLanguageCodeKey];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[hotKeys registerHotKeyWithKeyCode:11 modifierFlags:(NSShiftKeyMask | NSCommandKeyMask) target:self action:@selector(toggleTranslator:) object:nil];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Queries

- (void)doTranslate:(CRJSRemoteQuery *)query
{
	// translation data
	NSString* text	= query? [query.params valueForKey:CRGoogleTranslateTextKey] : [textSource stringValue];
	NSString* sCode = query? [query.params valueForKey:CRGoogleTranslateLanguageCodeKey] : [[self sourceLanguage] languageCode];
	NSString* dCode = [[self destinationLanguage] languageCode];
	
	// query
	NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
							text,	CRGoogleTranslateTextKey,
							sCode,	CRGoogleTranslateSourceLanguageCodeKey,
							dCode,	CRGoogleTranslateDestinationLanguageCodeKey,
							nil];
	[translate translateText:[CRJSRemoteQuery queryWithTarget:self action:@selector(translationComplete:) params:params]];
}

- (void)detectionComplete:(CRJSRemoteQuery *)query
{
	if ([query successStatus])
	{
		[self setSourceLanguage:[translate languageFromQuery:query]];
		
		// Check whether we are asked to translate right after that
		if ([[query.params valueForKey:LODeferredTranslateRequestKey] boolValue])
			[self doTranslate:query];
	}
}

- (void)translationComplete:(CRJSRemoteQuery *)query
{
	if ([query successStatus])
	{
		NSString* translation = [query.params valueForKey:CRGoogleTranslateTranslationKey];
		[textSource setStringValue:translation];
	}
}

- (void)translateReady:(CRChangeSignaler *)signaler
{
	[signaler release];
	
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	[self setSourceLanguage:[translate languageFromCode:[ud valueForKey:LOSourceLanguageCodeKey]]];
	[self setDestinationLanguage:[translate languageFromCode:[ud valueForKey:LODestinationLanguageCodeKey]]];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (void)showTranslator:(id)sender
{
	[translatePanel makeKeyAndOrderFront:self];
}

- (void)translate:(id)sender
{
	// Detect source language -> Translate
	if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOAutodetectLanguageKey] boolValue])
	{
		NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithBool:YES],	LODeferredTranslateRequestKey,
								[textSource stringValue],		CRGoogleTranslateTextKey,
								nil];
		[translate detectLanguage:[CRJSRemoteQuery queryWithTarget:self action:@selector(detectionComplete:) params:params]];
	}
	// Immediate translate
	else
		[self doTranslate:nil];
}

@end