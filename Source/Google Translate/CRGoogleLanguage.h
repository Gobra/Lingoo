//
//  CRGoogleLanguage.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/6/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRJSMapper.h"

//////////////////////////////////////////////////////////////////////
// GoogleTranslate language
//////////////////////////////////////////////////////////////////////
@interface CRGoogleLanguage : CRJSMapper<NSCopying>
{
	NSString* languageCode;
	NSString* languageName;
}

@property (readonly) NSString* languageCode;
@property (readonly) NSString* languageName;

- (id)initWithWebScriptObject:(WebScriptObject *)wo;

@end