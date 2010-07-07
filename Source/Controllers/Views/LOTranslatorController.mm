//
//  LOTranslatorController.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LOTranslatorController.h"

NSString* const LODeferredTranslateRequestKey = @"LODeferredTranslateRequestKey";

//////////////////////////////////////////////////////////////////////
// Translator controller
//////////////////////////////////////////////////////////////////////
@implementation LOTranslatorController

@synthesize translator;
@synthesize sourceLanguage;
@synthesize destinationLanguage;

@synthesize textSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
	}
	return self;
}

+ (id)controller
{
	return [[[self alloc] init] autorelease];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Delegate

- (IBAction)loadDefaults:(id)sender
{
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	[self setSourceLanguage:[translator languageFromCode:[ud valueForKey:LOSourceLanguageCodeKey]]];
	[self setDestinationLanguage:[translator languageFromCode:[ud valueForKey:LODestinationLanguageCodeKey]]];
}

- (IBAction)saveDefaults:(id)sender
{
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	if ([self sourceLanguage])
		[ud setValue:[[self sourceLanguage] languageCode] forKey:LOSourceLanguageCodeKey];
	if ([self destinationLanguage])
		[ud setValue:[[self destinationLanguage] languageCode] forKey:LODestinationLanguageCodeKey];
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
	[translator translateText:[CRJSRemoteQuery queryWithTarget:self action:@selector(translationComplete:) params:params]];
}

- (void)detectionComplete:(CRJSRemoteQuery *)query
{
	if ([query successStatus])
	{
		[self setSourceLanguage:[translator languageFromQuery:query]];
		
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

//////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (void)translate:(id)sender
{
	// Detect source language -> Translate
	if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOAutodetectLanguageKey] boolValue])
	{
		NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithBool:YES],	LODeferredTranslateRequestKey,
								[textSource stringValue],		CRGoogleTranslateTextKey,
								nil];
		[translator detectLanguage:[CRJSRemoteQuery queryWithTarget:self action:@selector(detectionComplete:) params:params]];
	}
	// Immediate translate
	else
		[self doTranslate:nil];
}

@end