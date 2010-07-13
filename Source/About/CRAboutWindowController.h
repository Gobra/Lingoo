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
	NSString*	applicationCopyright;
	NSImage*	applicationIcon;
	
	NSArray*	credits;
	NSTimer*	creditsTimer;
	NSUInteger	currentCredit;
	
	BOOL		showsExternals;
	BOOL		isSwitching;
	
@private
	NSTextView*	creditsView;
	NSTextField*externalsSwitcher;
	NSBox*		externalLicensesBox;
}

@property (readonly) NSString*	applicationName;
@property (readonly) NSImage*	applicationIcon;
@property (readonly) NSString*	applicationCopyright;
@property (readonly) NSString*	applicationVersion;

@property (assign) IBOutlet NSTextView* creditsView;
@property (assign) IBOutlet NSTextField*externalsSwitcher;
@property (assign) IBOutlet NSBox*		externalLicensesBox;

- (void)show;
- (IBAction)close:(id)sender;
- (IBAction)toggleExternalLicenses:(id)sender;
- (IBAction)showNextCredit:(id)sender;

@end