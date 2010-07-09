//
//  CRAboutWindowController.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

//////////////////////////////////////////////////////////////////////
// About window controller
//////////////////////////////////////////////////////////////////////
@interface CRAboutWindowController : NSWindowController
{
@protected
	NSString*	applicationName;
	NSString*	applicationVersion;
	NSImage*	applicationIcon;
	
	NSArray*	credits;
	NSTimer*	creditsTimer;
	NSUInteger	currentCredit;
	
@private
	NSTextView*	creditsView;
}

@property (assign) IBOutlet NSTextView* creditsView;

- (NSString *)applicationName;
- (NSImage *)applicationIcon;
- (NSString *)applicationVersion;

- (void)show;
- (IBAction)showNextCredit:(id)sender;

@end