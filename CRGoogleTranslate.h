//
//  CRGoogleTranslate.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/5/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRJSMapper.h"
#import "CRJSExec.h"

//////////////////////////////////////////////////////////////////////
// GoogleTranslate language
//////////////////////////////////////////////////////////////////////
@interface CRGoogleLanguage : CRJSMapper
{
	NSString* languageCode;
	NSString* languageName;
}

@property (readonly) NSString* languageCode;
@property (readonly) NSString* languageName;

- (id)initWithWebScriptObject:(WebScriptObject *)wo;

@end

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

@end