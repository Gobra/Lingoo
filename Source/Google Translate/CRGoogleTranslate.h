//
//  CRGoogleTranslate.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/5/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRJSRemoteQuery.h"
#import "CRJSExec.h"
#import "CRGoogleLanguage.h"

extern NSString* const CRGoogleTranslateTextKey;
extern NSString* const CRGoogleTranslateLanguageCodeKey;
extern NSString* const CRGoogleTranslateSourceLanguageCodeKey;
extern NSString* const CRGoogleTranslateDestinationLanguageCodeKey;
extern NSString* const CRGoogleTranslateTranslationKey;
extern NSString* const CRGoogleTranslateErrorKey;

//////////////////////////////////////////////////////////////////////
// JavaScript based GoogleTranslate wrapper
//////////////////////////////////////////////////////////////////////
@interface CRGoogleTranslate : NSObject
{
	CRJSExec*	jsExec;			// JavaScript command tool
	NSImage*	googleBrand;	// Google "powered by" image
	
	BOOL		isReady;		// Signals whether the module is ready for work
	BOOL		isWaiting;		// Signals whether the module is waiting for an answer
	NSArray*	languages;		// Available languages list
}

@property (readonly) CRJSExec*	jsExec;
@property (readonly) NSImage*	googleBrand;

@property (readonly) BOOL		isReady;
@property (readonly) BOOL		isWaiting;
@property (readonly) NSArray*	languages;

// Queries
- (void)detectLanguage:(CRJSRemoteQuery *)query;
- (void)translateText:(CRJSRemoteQuery *)query;

// Queries parsing
- (CRGoogleLanguage *)defaultLanguage;
- (CRGoogleLanguage *)languageFromCode:(NSString *)languageCode;
- (CRGoogleLanguage *)languageFromQuery:(CRJSRemoteQuery *)query;

@end