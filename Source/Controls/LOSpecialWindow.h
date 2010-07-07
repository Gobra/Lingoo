//
//  LOSpecialWindow.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 10/26/09.
//  Copyright 2009 Corner-A. All rights reserved.
//


//////////////////////////////////////////////////////////////////////
// Translation panel
//////////////////////////////////////////////////////////////////////
@interface LOSpecialWindow: NSPanel
{
	BOOL forceDisplay;
}

- (NSColor *)sizedHUDBackground;

@end