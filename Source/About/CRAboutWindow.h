//
//  CRAboutWindow.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 10/26/09.
//  Copyright 2009 Corner-A. All rights reserved.
//


//////////////////////////////////////////////////////////////////////
// About window
//////////////////////////////////////////////////////////////////////
@interface CRAboutWindow: NSPanel
{
    BOOL forceDisplay;
}

- (NSColor *)sizedHUDBackground;
- (void)addCloseWidget;

@end