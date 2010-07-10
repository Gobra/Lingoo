//
//  CRGoogleLanguagePair.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/10/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

//////////////////////////////////////////////////////////////////////
// GoogleTranslate language pair
//////////////////////////////////////////////////////////////////////
@interface CRGoogleLanguagePair : NSObject<NSCopying, NSCoding>
{
	id					delegate;
	CRGoogleLanguage*	sourceLanguage;
	CRGoogleLanguage*	destinationLanguage;
}

@property (assign)				id					delegate;
@property (retain, readwrite)	CRGoogleLanguage*	sourceLanguage;
@property (retain, readwrite)	CRGoogleLanguage*	destinationLanguage;

- (id)initWithSource:(CRGoogleLanguage *)source destination:(CRGoogleLanguage *)destination;
+ (id)pairWithSource:(CRGoogleLanguage *)source destination:(CRGoogleLanguage *)destination;

@end

//////////////////////////////////////////////////////////////////////
// Language pair
//////////////////////////////////////////////////////////////////////
@interface NSObject(CRGoogleLanguagePair)

- (void)pairDestinationChanged:(CRGoogleLanguagePair *)pair;

@end