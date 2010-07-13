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

@synthesize contentBox;
@synthesize modeSwitch;

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
		viewSwitchInterval = 0.5f;
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
	[[self window] setBackgroundColor:[NSColor colorWithCalibratedWhite:0.05f alpha:0.85f]];
	[[self window] setOpaque:NO];
	
	if (deferredViewLoad != -1)
	{
		[modeSwitch setSelectedSegment:deferredViewLoad];
		[self showViewAtIndex:deferredViewLoad];
	}
}

//////////////////////////////////////////////////////////////////////
#pragma mark Views switching

- (NSRect)frameRectToFitContent:(NSSize)aSize
{
	NSRect newContentRect = [[self window] contentRectForFrameRect:[[self window] frame]];
	newContentRect.size = aSize;
	return [[self window] frameRectForContentRect:newContentRect];
}

- (void)animateToContentSize:(NSSize)aSize
{
	NSRect newContentRect = [[self window] contentRectForFrameRect:[[self window] frame]];
	newContentRect.size = aSize;
	NSRect newFrame = [[self window] frameRectForContentRect:newContentRect];
	[[self window] setFrame:newFrame display:YES animate:YES];
}

- (void)setContentController:(LOTranslatorController *)aController
{
	inAnimation = YES;
	
	double stepDuration = viewSwitchInterval / 3.0;
	NSSize viewSize = [[selectedViewController valueForKey:@"originalSize"] sizeValue];
	CRAnimationStack* stack = [[CRAnimationStack alloc] init];
	
	// fade out
	[stack appendAnimationForTarget:contentBox
						  withValue:[NSNumber numberWithFloat:0.0f]
							forKey:@"alphaValue"
					   withDuration:stepDuration];
	
	// move frame
	[stack appendAnimationForTarget:[self window]
						  withValue:[NSValue valueWithRect:[self frameRectToFitContent:viewSize]]
							forKey:@"frame"
					   withDuration:stepDuration];
	
	// immediately change the content view & size
	[stack appendAnimationForTarget:contentBox
						  withValue:[aController view]
							forKey:@"contentView"
					   withDuration:0];
	
	[stack appendAnimationForTarget:contentBox
						  withValue:[NSValue valueWithSize:viewSize]
							forKey:@"frameSize"
					   withDuration:0];
	
	// fade in
	[stack appendAnimationForTarget:contentBox
						  withValue:[NSNumber numberWithFloat:1.0f]
							forKey:@"alphaValue"
					   withDuration:stepDuration];
	
	// run
	[stack setDelegate:self];
	[stack playback];
}

- (void)animationStackPlayed:(CRAnimationStack *)stack
{
	[stack release];
	[selectedViewController activate];
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
		[self setContentController:selectedViewController];
	
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
	{
		[modeSwitch setSelectedSegment:index];
		[self showViewAtIndex:index];
	}
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

- (IBAction)selectModeWithSegmentedControl:(id)sender
{
	switch ([modeSwitch selectedSegment])
	{
		case 0: [self showLightView:self]; break;
		case 1:	[self showMiddleView:self]; break;
		case 2: [self showHeavyView:self]; break;
			
		default:
			break;
	}
}

@end