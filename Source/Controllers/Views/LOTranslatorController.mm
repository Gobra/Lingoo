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
		
		ignoreAction = NO;
	}
	return self;
}

+ (id)controller
{
	return [[[self alloc] init] autorelease];
}

- (void)awakeFromNib
{
	[self loadSizeFromDefaults];
	
	[swapButton setImage:[NSImage imageNamed:@"Swap"]];
}

- (void)activate
{
	[textSource selectText:self];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Setting from UserDefaults

+ (NSSize)defaultSize;
{
	return NSZeroSize;
}

- (NSSize)defaultSize
{
	return [[self class] defaultSize];
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

- (BOOL)canScaleVertically
{
	return YES;
}

//////////////////////////////////////////////////////////////////////
#pragma mark Size

- (NSString *)sizeDefaultsKey
{
	return nil;
}

- (void)loadSizeFromDefaults
{
	if ([self sizeDefaultsKey])
	{
		NSString* valSize = [[NSUserDefaults standardUserDefaults] valueForKey:[self sizeDefaultsKey]];
		[[self view] setFrameSize:NSSizeFromString(valSize)];
	}
}

- (void)saveSizeToDefaults
{
	if ([self sizeDefaultsKey])
	{
		[[NSUserDefaults standardUserDefaults] setValue:NSStringFromSize([[self view] frame].size) forKey:[self sizeDefaultsKey]];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

//////////////////////////////////////////////////////////////////////
#pragma mark Delegate

- (IBAction)loadLanguageDefaults:(id)sender
{
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	[self setSourceLanguage:[[LOShared translator] languageFromCode:[ud valueForKey:LOSourceLanguageCodeKey]]];
	[self setDestinationLanguage:[[LOShared translator] languageFromCode:[ud valueForKey:LODestinationLanguageCodeKey]]];
}

- (IBAction)saveLanguageDefaults:(id)sender
{
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	if ([self sourceLanguage])
		[ud setValue:[[self sourceLanguage] languageCode] forKey:LOSourceLanguageCodeKey];
	if ([self destinationLanguage])
		[ud setValue:[[self destinationLanguage] languageCode] forKey:LODestinationLanguageCodeKey];
	[ud synchronize];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Errors

- (void)handleError:(CRJSRemoteQuery *)query
{
	[[self translationDestination] setStringValue:[query.params valueForKey:CRGoogleTranslateErrorKey]];
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
	else
		[self handleError:query];
}

- (void)translationComplete:(CRJSRemoteQuery *)query
{
	if ([query successStatus])
	{
		ignoreAction = YES;

		NSString* translation = [query.params valueForKey:CRGoogleTranslateTranslationKey];
		[[self translationDestination] setStringValue:translation];
		if ([self autoselectTranslated])
			[[self translationDestination] selectText:self];
		if ([self autoclipboardTranslated])
		{
			NSPasteboard* clipboard = [NSPasteboard generalPasteboard];
			[clipboard setString:translation forType:NSStringPboardType];
		}
		
		ignoreAction = NO;
	}
	else
		[self handleError:query];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (IBAction)swapLanguages:(id)sender
{
	// turn the auto-detect off
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:LOAutodetectLanguageKey];
	
	CRGoogleLanguage* oldDest = [self.destinationLanguage retain];
	self.destinationLanguage = self.sourceLanguage;
	self.sourceLanguage = oldDest;
	[oldDest release];
}

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
	NSString* sourceText = [textSource stringValue];
	if (ignoreAction || !sourceText || 0 == [sourceText length])
		return;
	
	// Detect source language -> Translate
	if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOAutodetectLanguageKey] boolValue])
	{
		NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithBool:YES],	LODeferredTranslateRequestKey,
								sourceText,						CRGoogleTranslateTextKey,
								nil];
		[[LOShared translator] detectLanguage:[CRJSRemoteQuery queryWithTarget:self action:@selector(detectionComplete:) params:params]];
	}
	// Immediate translate
	else
		[self doTranslate:nil];
}

@end