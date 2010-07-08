//
//  LOTranslatorWindowController.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRGoogleTranslate.h"
#import "LOTranslatorController.h"

//////////////////////////////////////////////////////////////////////
// Translator window controller
//////////////////////////////////////////////////////////////////////
@interface LOTranslatorWindowController : NSWindowController
{
	CRGoogleTranslate*	translator;
	NSArray*			viewControllers;
	NSViewController*	selectedViewController;
	
@public
	NSView*				toolbarView;
	NSBox*				contentBox;
}

@property (assign) IBOutlet NSView*	toolbarView;
@property (assign) IBOutlet NSView*	contentBox;

- (void)showViewAtIndex:(NSUInteger)index;

- (IBAction)fadeIn:(id)sender;
- (IBAction)fadeOut:(id)sender;

- (IBAction)readTextFromClipboard:(id)sender;

- (IBAction)showLightView:(id)sender;
- (IBAction)showMiddleView:(id)sender;
- (IBAction)showHeavyView:(id)sender;

@end