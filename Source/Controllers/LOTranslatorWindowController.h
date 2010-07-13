//
//  LOTranslatorWindowController.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LOTranslatorController.h"
#import "CRAnimationStack.h"

//////////////////////////////////////////////////////////////////////
// Translator window controller
//////////////////////////////////////////////////////////////////////
@interface LOTranslatorWindowController : NSWindowController
{
	NSArray*				viewControllers;
	LOTranslatorController*	selectedViewController;
	int						deferredViewLoad;
	
@private
	BOOL					inAnimation;
	NSTimeInterval			viewSwitchInterval;
	
@public
	NSBox*					contentBox;
	NSSegmentedControl*		modeSwitch;
}

@property (assign) IBOutlet NSBox*				contentBox;
@property (assign) IBOutlet NSSegmentedControl*	modeSwitch;

- (void)showViewAtIndex:(NSUInteger)index;

- (IBAction)fadeIn:(id)sender;
- (IBAction)fadeOut:(id)sender;

- (IBAction)readTextFromClipboard:(id)sender;

- (IBAction)showLightView:(id)sender;
- (IBAction)showMiddleView:(id)sender;
- (IBAction)showHeavyView:(id)sender;
- (IBAction)selectModeWithSegmentedControl:(id)sender;

@end