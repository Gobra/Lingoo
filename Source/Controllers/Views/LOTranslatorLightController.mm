//
//  LOTranslatorLightController.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LOTranslatorLightController.h"

//////////////////////////////////////////////////////////////////////
// Translator small-size view controller
//////////////////////////////////////////////////////////////////////
@implementation LOTranslatorLightController

- (id)init
{
	self = [super initWithNibName:@"TranslatorLightView" bundle:nil];
	if (self)
	{
	}
	return self;
}

+ (NSSize)defaultSize;
{
	return NSMakeSize(400, 50);
}

- (NSString *)sizeDefaultsKey
{
	return LOTranslatorLightSizeKey;
}

- (BOOL)canScaleVertically
{
	return NO;
}

@end