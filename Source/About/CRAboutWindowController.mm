//
//  CRAboutWindowController.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRAboutWindowController.h"

//////////////////////////////////////////////////////////////////////
// About window controller
//////////////////////////////////////////////////////////////////////
@implementation CRAboutWindowController

@dynamic	applicationName;
@dynamic	applicationIcon;
@dynamic	applicationCopyright;
@dynamic	applicationVersion;

@synthesize creditsView;
@synthesize externalsSwitcher;
@synthesize externalLicensesBox;

- (id)init
{
	self = [self initWithWindowNibName:@"CRAboutWindow"];
	if (self)
	{
		// immediate window loading
		[self loadWindow];
		
		// credits
		currentCredit = 0;
		showsExternals = NO;
		isSwitching = NO;
		credits = [[[NSBundle mainBundle] pathsForResourcesOfType:@"rtf" inDirectory:@"Credits"] retain];
		[self showNextCredit:self];
	}
	return self;
}

- (void)dealloc
{
	[creditsTimer invalidate];
	
	[credits release];
	[applicationName release];
	[applicationVersion release];
	[applicationIcon release];
	[super dealloc];
}

- (void)awakeFromNib
{
	[[self window] setLevel:NSNormalWindowLevel];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Properties

- (NSString *)applicationName
{
	if (!applicationName)
		applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
	return applicationName;
}

- (NSString *)applicationVersion
{
	if (!applicationVersion)
		applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	return applicationVersion;
}

- (NSString *)applicationCopyright
{
	if (!applicationCopyright)
		applicationCopyright = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSHumanReadableCopyright"];
	return applicationCopyright;
}

- (NSImage *)applicationIcon
{
	if (!applicationIcon)
		applicationIcon = [NSImage imageNamed:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"]];
	return applicationIcon;
}

//////////////////////////////////////////////////////////////////////
#pragma mark Credits

NSTimeInterval animationDuration = 0.25f;

- (void)fadeCreditIn:(NSString *)path
{
	[creditsView readRTFDFromFile:path];
	
	[[NSAnimationContext currentContext] setDuration:animationDuration];
	[[creditsView animator] setAlphaValue:1.0f];
}

- (void)showNextCredit:(id)sender
{
	if ([credits count] > 0)
	{
		// tick
		if (sender != self)
		{
			[[NSAnimationContext currentContext] setDuration:animationDuration];
			[[creditsView animator] setAlphaValue:0.0f];
			[self performSelector:@selector(fadeCreditIn:) withObject:[credits objectAtIndex:currentCredit] afterDelay:animationDuration];
		}
		// just load initial
		else
		{
			[creditsView readRTFDFromFile:[credits objectAtIndex:currentCredit]];
		}
		
		currentCredit = (currentCredit + 1) % [credits count];
	}
}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
	if ([credits count] > 0)
		creditsTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(showNextCredit:) userInfo:nil repeats:YES];
}

- (void)windowDidResignKey:(NSNotification *)notification
{
	[creditsTimer invalidate];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Action

- (void)show
{
	[self showWindow:self];
}

- (IBAction)close:(id)sender
{
	[[self window] orderOut:self];
	[[self window] close];
}

- (void)animateToContentSize:(NSDictionary *)dict
{
	NSSize newSize = [[dict valueForKey:@"size"] sizeValue];
	NSRect oldFrame = [[self window] frame];
	NSRect newFrame = NSMakeRect(oldFrame.origin.x, oldFrame.origin.y + oldFrame.size.height - newSize.height, newSize.width, newSize.height);
	[[self window] setFrame:newFrame display:YES animate:YES];
	
	isSwitching = [[dict valueForKey:@"state"] boolValue];
}

- (void)animateToShow:(NSDictionary *)dict
{
	BOOL show = [[dict valueForKey:@"show"] boolValue];
	BOOL state = [[dict valueForKey:@"state"] boolValue];
	
	NSString* text = show? NSLocalizedString(@"about.hide_licenses", @"") : NSLocalizedString(@"about.show_licenses", @"");
	[[externalsSwitcher animator] setStringValue:text];
	[[externalLicensesBox animator] setHidden:!show];
	
	isSwitching = state;
}

- (void)toggleExternalLicenses:(id)sender
{
	const NSSize internalSize = NSMakeSize(320, 221);
	const NSSize externalSize = NSMakeSize(368, 373);
	const CGFloat delay = [[NSAnimationContext currentContext] duration];
	
	if (isSwitching)
		return;
	
	isSwitching = YES;
	if (showsExternals)
	{
		showsExternals = NO;
		[self performSelector:nil withObject:nil afterDelay:0];
		[self animateToShow:[NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:NO], @"show",
							 [NSNumber numberWithBool:YES],@"state",
							 nil]];
		[self performSelector:@selector(animateToContentSize:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:
																		   [NSValue valueWithSize:internalSize], @"size",
																		   [NSNumber numberWithBool:NO],		 @"state",
																		   nil] afterDelay:delay];
	}
	else
	{
		showsExternals = YES;
		[self animateToContentSize:[NSDictionary dictionaryWithObjectsAndKeys:
									[NSValue valueWithSize:externalSize],	@"size",
									[NSNumber numberWithBool:YES],			@"state",
									nil]];
		[self performSelector:@selector(animateToShow:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:
																	[NSNumber numberWithBool:YES],	@"show",
																	[NSNumber numberWithBool:NO],	@"state",
																	nil] afterDelay:delay];
	}
}

@end