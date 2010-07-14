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
		firstApply = YES;
		viewSwitchInterval = 0.5f;
		
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
	
	// load view
	int index = [[[NSUserDefaults standardUserDefaults] valueForKey:LOTranslatorTypeIndexKey] intValue];
	[modeSwitch setSelectedSegment:index];
	[self showViewAtIndex:index];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Views switching

- (NSRect)frameRectToFitContent:(NSSize)aSize
{
	NSRect newContentRect = [[self window] contentRectForFrameRect:[[self window] frame]];
	newContentRect.origin.y -= aSize.height - newContentRect.size.height;
	newContentRect.size = aSize;
	
	return [[self window] frameRectForContentRect:newContentRect];
}

- (void)setContentController:(LOTranslatorController *)aController
{
	inAnimation = YES;
	
	// we set 0 animation length for the first time, this discards animation
	// and sets all values immediately
	double stepDuration = firstApply? 0 : viewSwitchInterval / 3.0;
	NSSize viewSize = [selectedViewController view].frame.size;
	CRAnimationStack* stack = [[CRAnimationStack alloc] init];
	
	// fade out
	[stack appendAnimationForTarget:contentBox
						  withValue:[NSNumber numberWithFloat:0.0f]
							forKey:@"alphaValue"
						   duration:stepDuration];
	
	// remove the content view
	[stack appendAnimationForTarget:contentBox
						  withValue:nil
							 forKey:@"contentView"
						   duration:0];
	
	// move frame (NSAnimation is better here because is natively supported and updates display)
	[stack appendAnimationForTarget:[self window]
						  withValue:[NSValue valueWithRect:[self frameRectToFitContent:viewSize]]
							 forKey:@"frame"
						   duration:stepDuration];
	
	// immediately change the content view & size
	[stack appendAnimationForTarget:contentBox
						  withValue:[NSValue valueWithSize:viewSize]
							forKey:@"frameSize"
						   duration:0];
	
	[stack appendAnimationForTarget:contentBox
						  withValue:[aController view]
							 forKey:@"contentView"
						   duration:0];
	
	// fade in
	[stack appendAnimationForTarget:contentBox
						  withValue:[NSNumber numberWithFloat:1.0f]
							forKey:@"alphaValue"
						   duration:stepDuration];
	
	// run
	[stack setDelegate:self];
	[stack playback];
	
	firstApply = NO;
}

- (void)animationStackPlayed:(CRAnimationStack *)stack
{
	[stack release];
	[selectedViewController activate];
	
	// Constraints
	NSSize viewMinimumSize = [selectedViewController defaultSize];
	NSSize viewMaximumSize = NSMakeSize(800, 600);
	if (![selectedViewController canScaleVertically])
		viewMaximumSize.height = viewMinimumSize.height;
	[[self window] setMinSize:viewMinimumSize];
	[[self window] setMaxSize:viewMaximumSize];
	
	inAnimation = NO;
}

- (void)showViewAtIndex:(NSUInteger)index
{
	if (inAnimation)
		return;
	
	LOTranslatorController* oldController = selectedViewController;
	[oldController saveLanguageDefaults:self];
	selectedViewController = [viewControllers objectAtIndex:index];
	
	// data transfer
	[selectedViewController loadLanguageDefaults:self];
	
	// view switch
	if (oldController != selectedViewController)
		[self setContentController:selectedViewController];
	
	// save in Defaults
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:index] forKey:LOTranslatorTypeIndexKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Delegate

- (void)windowDidResize:(NSNotification *)notification
{
	// resize the box
	[contentBox setFrame:NSMakeRect(0, 0, [[[self window] contentView] frame].size.width, [[[self window] contentView] frame].size.height)];
	
	// save size of the controller
	[selectedViewController saveSizeToDefaults];
}

- (void)windowWillClose:(NSNotification *)notification
{
	[selectedViewController saveLanguageDefaults:nil];
}
																				  
- (void)translatorIsReady:(NSNotification *)notification
{
	if (selectedViewController)
		[selectedViewController loadLanguageDefaults:self];
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
	[[self window] makeKeyAndOrderFront:self];
	[[[self window] animator] setAlphaValue:1.0f];
}

- (IBAction)readTextFromClipboard:(id)sender;
{
	[selectedViewController readTextFromClipboard:sender];
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