//
//  LOTranslatorHeavyController.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LOTranslatorController.h"

//////////////////////////////////////////////////////////////////////
// Translator big-size view controller
//////////////////////////////////////////////////////////////////////
@interface LOTranslatorHeavyController : LOTranslatorController
{
@public
	NSTextField* textDestination;
}
@property (assign) IBOutlet NSTextField* textDestination;

@end