//
//  LOTranslatorHeavyController.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LOTranslatorHeavyController.h"

//////////////////////////////////////////////////////////////////////
// Translator big-size view controller
//////////////////////////////////////////////////////////////////////
@implementation LOTranslatorHeavyController

@synthesize textDestination;

- (id)init
{
	self = [super initWithNibName:@"TranslatorHeavyView" bundle:nil];
	if (self)
	{
	}
	return self;
}

- (void)translationComplete:(CRJSRemoteQuery *)query
{
	if ([query successStatus])
	{
		NSString* translation = [query.params valueForKey:CRGoogleTranslateTranslationKey];
		[textDestination setStringValue:translation];
	}
}

@end