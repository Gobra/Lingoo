//
//  LOShared.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/10/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LOShared.h"

//////////////////////////////////////////////////////////////////////
// A wrapper for easier data access
//////////////////////////////////////////////////////////////////////
@implementation LOShared

+ (CRGoogleTranslate *)translator
{
	return [(NSObject *)[NSApp delegate] valueForKey:@"translator"];
}

+ (CRGoogleLanguagePairsSet *)languagePairs
{
	return [(NSObject *)[NSApp delegate] valueForKey:@"languagePairs"];
}

@end