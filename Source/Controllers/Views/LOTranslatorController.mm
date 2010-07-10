//
//  LO[LOShared translator]Controller.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LOTranslatorController.h"

NSString* const LODeferredTranslateRequestKey = @"LODeferredTranslateRequestKey";

//////////////////////////////////////////////////////////////////////
// LOTranslatorController
//////////////////////////////////////////////////////////////////////
@implementation LOTranslatorController

@synthesize sourceLanguage;
@synthesize destinationLanguage;

@synthesize textSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		[self loadView];
	}
	return self;
}

+ (id)controller
{
	return [[[self alloc] init] autorelease];
}

- (void)awakeFromNib
{
	originalSize = [[self view] frame].size;
}

//////////////////////////////////////////////////////////////////////
#pragma mark Setting from UserDefaults

- (NSSize)originalSize
{
	return originalSize;
}

- (BOOL)autoselectTranslated
{
	return [[[NSUserDefaults standardUserDefaults] valueForKey:LOAutoselectTranslationKey] boolValue];
}

- (BOOL)useLanguagePairs
{
	return [[[NSUserDefaults standardUserDefaults] valueForKey:LOUseLanguagePairsKey] boolValue];
}

- (BOOL)autotranslateForClipboard
{
	return [[[NSUserDefaults standardUserDefaults] valueForKey:LOAutotranslateFromClipboardKey] boolValue];
}

- (BOOL)autoclipboardTranslated
{
	return [[[NSUserDefaults standardUserDefaults] valueForKey:LOAutoclipboardTranslationKey] boolValue];
}

- (NSTextField *)translationDestination
{
	return textSource;
}

//////////////////////////////////////////////////////////////////////
#pragma mark Delegate

- (IBAction)loadDefaults:(id)sender
{
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	[self setSourceLanguage:[[LOShared translator] languageFromCode:[ud valueForKey:LOSourceLanguageCodeKey]]];
	[self setDestinationLanguage:[[LOShared translator] languageFromCode:[ud valueForKey:LODestinationLanguageCodeKey]]];
}

- (IBAction)saveDefaults:(id)sender
{
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	if ([self sourceLanguage])
		[ud setValue:[[self sourceLanguage] languageCode] forKey:LOSourceLanguageCodeKey];
	if ([self destinationLanguage])
		[ud setValue:[[self destinationLanguage] languageCode] forKey:LODestinationLanguageCodeKey];
	[ud synchronize];
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
	[[LOShared translator] translateText:[CRJSRemoteQuery queryWithTarget:self action:@selector(translationComplete:) params:params]];
}

- (void)detectionComplete:(CRJSRemoteQuery *)query
{
	if ([query successStatus])
	{
		// Source language is set
		CRGoogleLanguage* newSource = [[LOShared translator] languageFromQuery:query];
		[self setSourceLanguage:newSource];
		
		// Set destination language if needed
		if ([self useLanguagePairs])
		{
			CRGoogleLanguage* autoLanguage = [[LOShared languagePairs] destinationLanguageForSource:[newSource languageCode]];
			if (autoLanguage)
				[self setDestinationLanguage:autoLanguage];
		}
		
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
		[[self translationDestination] setStringValue:translation];
		if ([self autoselectTranslated])
			[[self translationDestination] selectText:self];
		if ([self autoclipboardTranslated])
		{
			NSPasteboard* clipboard = [NSPasteboard generalPasteboard];
			[clipboard setString:translation forType:NSStringPboardType];
		}
	}
}

//////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (IBAction)readTextFromClipboard:(id)sender
{
	// read the text
	NSPasteboard* pboard = [NSPasteboard generalPasteboard];
	NSString* text = [pboard stringForType:NSStringPboardType];
	if (text)
	{
		[textSource setStringValue:text];
		
		if ([self autotranslateForClipboard])
			[self translate:self];
	}
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
		[[LOShared translator] detectLanguage:[CRJSRemoteQuery queryWithTarget:self action:@selector(detectionComplete:) params:params]];
	}
	// Immediate translate
	else
		[self doTranslate:nil];
}

@end