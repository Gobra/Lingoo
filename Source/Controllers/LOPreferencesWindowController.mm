//
//  LOPreferencesWindowController.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LOPreferencesWindowController.h"

//////////////////////////////////////////////////////////////////////
// Preferences window controller
//////////////////////////////////////////////////////////////////////
@implementation LOPreferencesWindowController

+ (void)registerDefaults
{
	// Defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithBool:YES],	LOFirstRunKey,
	  [NSNumber numberWithInt:0],		LOTranslatorTypeIndexKey,
	  [NSNumber numberWithBool:YES],	LOAutodetectLanguageKey,
	  @"en",							LOSourceLanguageCodeKey,
	  @"en",							LODestinationLanguageCodeKey,
	  nil]
	 ];
}

- (id)init
{
	self = [super initWithWindowNibName:@"Preferences"];
	if (self)
	{
	}
	return self;
}

@end