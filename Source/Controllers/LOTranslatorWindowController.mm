//
//  LOTranslatorWindowController.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LOTranslatorWindowController.h"

#import "LOTranslatorLightController.h"
#import "LOTranslatorMiddleController.h"
#import "LOTranslatorHeavyController.h"

//////////////////////////////////////////////////////////////////////
// Translator window controller
//////////////////////////////////////////////////////////////////////
@implementation LOTranslatorWindowController

@synthesize toolbarView;
@synthesize footerbarView;
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
		
		// Animation
		inAnimation = NO;
		viewSwitchInterval = 0.25f;
		deferredViewLoad = -1;
		
		// Notification
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(translatorIsReady:) name:LOTranslatorIsReadyNotification object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

- (void)awakeFromNib
{
	if (deferredViewLoad != -1)
		[self showViewAtIndex:deferredViewLoad];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Views switching

- (void)animateToContentSize:(NSSize)aSize
{
	CGFloat extraHeight = toolbarView.frame.size.height + footerbarView.frame.size.height;
	NSSize newSize = NSMakeSize(aSize.width, extraHeight + aSize.height);
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
	[aController activate];
	
	inAnimation = NO;
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
		inAnimation = YES;
		
		[[NSAnimationContext currentContext] setDuration:viewSwitchInterval];
		[[contentBox animator] setAlphaValue:0.0f];
		[self performSelector:@selector(setContentController:) withObject:selectedViewController afterDelay:viewSwitchInterval];
	}
	
	// save in Defaults
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:index] forKey:LOTranslatorTypeIndexKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Delegate

- (void)windowWillClose:(NSNotification *)notification
{
	if ([selectedViewController isKindOfClass:[LOTranslatorController class]])
		[(LOTranslatorController *)selectedViewController saveDefaults:nil];
}
																				  
- (void)translatorIsReady:(NSNotification *)notification
{
	int index = [[[NSUserDefaults standardUserDefaults] valueForKey:LOTranslatorTypeIndexKey] intValue];
	if ([self isWindowLoaded])
		[self showViewAtIndex:index];
	else
		deferredViewLoad = index;
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