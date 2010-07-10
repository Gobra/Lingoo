//
//  CRGoogleLanguagePairsSet.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/10/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

extern NSString* const CRLanguagePairAnyLanguageMarker;

//////////////////////////////////////////////////////////////////////
// GoogleTranslate language pair set
//////////////////////////////////////////////////////////////////////
@interface CRGoogleLanguagePairsSet : NSObject<NSCoding>
{
	CRGoogleTranslate*	translator;
	
	NSString*			autosaveName;
	NSArray*			pairs;
	NSMutableArray*		unusedSourceLanguages;
}

@property (assign)		CRGoogleTranslate*	translator;
@property (copy)		NSString*			autosaveName;
@property (readonly)	NSArray*			pairs;
@property (readonly)	NSArray*			unusedSourceLanguages;

- (id)init;
+ (id)defaultData;

- (void)readFromDefaults;
- (void)flushToDefaults;

- (void)addDestination:(CRGoogleLanguage *)destinationLanguage forSource:(CRGoogleLanguage *)sourceLanguage;
- (void)removePairForSource:(CRGoogleLanguage *)sourceLanguage;
- (void)removePair:(CRGoogleLanguagePair *)pair;

- (CRGoogleLanguage *)targetLanguageForAnyMarker;
- (CRGoogleLanguage *)destinationLanguageForSource:(NSString *)sourceCode;

@end