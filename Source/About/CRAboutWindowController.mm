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

@synthesize creditsView;

- (id)init
{
	self = [self initWithWindowNibName:@"AboutWindow"];
	if (self)
	{
		[self loadWindow];
		
		currentCredit = 0;
		credits = [[[NSBundle mainBundle] pathsForResourcesOfType:@"rtf" inDirectory:@"Credits"] retain];
		[self showNextCredit:self];
	}
	return self;
}

- (void)dealloc
{
	[creditsTimer invalidate];
	[creditsTimer release];
	
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
			
			currentCredit = (currentCredit + 1) % [credits count];
		}
		// just load initial
		else
		{
			[creditsView readRTFDFromFile:[credits objectAtIndex:currentCredit]];
		}
	}
}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
	if ([credits count] > 0)
		creditsTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(showNextCredit:) userInfo:nil repeats:YES];
}

- (void)windowDidResignKey:(NSNotification *)notification
{
	[creditsTimer invalidate];
	[creditsTimer release];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Action

- (void)show
{
	[self showWindow:self];
}

@end