//
//  LOTranslatorWindowController.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LOTranslatorWindowController.h"
#import "CRChangeSignaler.h"

#import "LOTranslatorLightController.h"
#import "LOTranslatorMiddleController.h"
#import "LOTranslatorHeavyController.h"

//////////////////////////////////////////////////////////////////////
// Translator window controller
//////////////////////////////////////////////////////////////////////
@implementation LOTranslatorWindowController

@synthesize toolbarView;
@synthesize contentBox;

- (id)init
{
	self = [super initWithWindowNibName:@"TranslatorWindow"];
	if (self)
	{
		// View controllers
		viewControllers = [[NSArray alloc] initWithObjects:
						   [LOTranslatorLightController controller],
						   [LOTranslatorMiddleController controller],
						   [LOTranslatorHeavyController controller],
						   nil];
		
		// Google.Translate
		translator = [[CRGoogleTranslate alloc] init];
		CRChangeSignaler* signaler = [CRChangeSignaler signalWithObject:translator keyPath:@"isReady" target:self action:@selector(translateReady:)];
		[signaler retain];
		
		// Animation
		inAnimation = NO;
		viewSwitchInterval = 0.25f;
	}
	return self;
}

- (void)dealloc
{
	[translator release];
	[super dealloc];
}

- (void)awakeFromNib
{
	[self showViewAtIndex:0];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Views switching

- (void)animateToContentSize:(NSSize)aSize
{
	NSSize newSize = NSMakeSize(aSize.width, toolbarView.frame.size.height + aSize.height);
	NSRect oldFrame = [[self window] frame];
	NSRect newFrame = NSMakeRect(oldFrame.origin.x, oldFrame.origin.y + oldFrame.size.height - newSize.height, newSize.width, newSize.height);
	[[self window] setFrame:newFrame display:YES animate:YES];
}

- (void)setContentController:(LOTranslatorController *)aController
{
	NSSize viewSize = [[selectedViewController valueForKey:@"originalSize"] sizeValue];
	
	[[NSAnimationContext currentContext] setDuration:viewSwitchInterval];
	[contentBox setContentView:[aController view]];
	[contentBox setFrameSize:viewSize];
	[[contentBox animator] setAlphaValue:1.0f];
	[self animateToContentSize:viewSize];
}

- (void)showViewAtIndex:(NSUInteger)index
{
	if (inAnimation)
		return;
	
	id oldController = selectedViewController;
	if ([oldController isKindOfClass:[LOTranslatorController class]])
		[(LOTranslatorController *)oldController saveDefaults:self];
	selectedViewController = [viewControllers objectAtIndex:index];
	
	// data transfer
	if ([selectedViewController isKindOfClass:[LOTranslatorController class]])
		[(LOTranslatorController *)selectedViewController loadDefaults:self];
	
	// view switch
	if (oldController != selectedViewController)
	{
		[[NSAnimationContext currentContext] setDuration:viewSwitchInterval];
		[[contentBox animator] setAlphaValue:0.0f];
		[self performSelector:@selector(setContentController:) withObject:selectedViewController afterDelay:viewSwitchInterval];
	}
	
	// save in Defaults
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:index] forKey:LOTranslatorTypeIndexKey];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Delegate

- (void)windowWillClose:(NSNotification *)notification
{
	if ([selectedViewController isKindOfClass:[LOTranslatorController class]])
		[(LOTranslatorController *)selectedViewController saveDefaults:nil];
}

- (void)translateReady:(CRChangeSignaler *)signaler
{
	// we don't need signaler anymore
	[signaler release];
	
	// set controllers up
	for (NSViewController* controller in viewControllers)
		if ([controller isKindOfClass:[LOTranslatorController class]])
			[(LOTranslatorController *)controller setTranslator:translator];
	
	// view
	int index = [[[NSUserDefaults standardUserDefaults] valueForKey:LOTranslatorTypeIndexKey] intValue];
	[self showViewAtIndex:index];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (IBAction)fadeOut:(id)sender
{
	[[[self window] animator] setAlphaValue:0.0f];
	[[self window] performSelector:@selector(orderOut:) withObject:nil afterDelay:[[NSAnimationContext currentContext] duration]];
}

- (IBAction)fadeIn:(id)sender
{
	[[self window] setAlphaValue:0.0f];
	[self showWindow:self];
	[[[self window] animator] setAlphaValue:1.0f];
}

- (IBAction)readTextFromClipboard:(id)sender;
{
	if ([selectedViewController isKindOfClass:[LOTranslatorController class]])
		[(LOTranslatorController *)selectedViewController readTextFromClipboard:sender];
}

- (IBAction)showLightView:(id)sender
{
	[self showViewAtIndex:0];
}

- (IBAction)showMiddleView:(id)sender
{
	[self showViewAtIndex:1];
}

- (IBAction)showHeavyView:(id)sender
{
	[self showViewAtIndex:2];
}

@end