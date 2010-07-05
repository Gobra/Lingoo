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

//////////////////////////////////////////////////////////////////////
// JavaScript based GoogleTranslate wrapper
//////////////////////////////////////////////////////////////////////
@interface CRGoogleTranslate : NSObject
{
	CRJSExec*	jsExec;
	
	BOOL		isReady;
	NSArray*	languages;
}

@property (readonly) CRJSExec*	jsExec;

@property (readonly) BOOL		isReady;
@property (readonly) NSArray*	languages;

// Queries
- (void)detectLanguage:(CRJSRemoteQuery *)query;
- (void)translateText:(CRJSRemoteQuery *)query;

// Queries parsing
- (CRGoogleLanguage *)languageFromQuery:(CRJSRemoteQuery *)query;

@end