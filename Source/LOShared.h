//
//  LOShared.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/10/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

//////////////////////////////////////////////////////////////////////
// A wrapper for easier data access
//////////////////////////////////////////////////////////////////////
@interface LOShared : NSObject
{
}

+ (CRGoogleTranslate *)translator;
+ (CRGoogleLanguagePairsSet *)languagePairs;

@end