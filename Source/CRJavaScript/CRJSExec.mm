//
//  CRJSExec.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/5/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRJSExec.h"

//////////////////////////////////////////////////////////////////////
// CRJSExec
//////////////////////////////////////////////////////////////////////
@implementation CRJSExec

@synthesize view;
@synthesize script;
@synthesize delegate;
@synthesize reloadDelay;

- (id)init
{
	self = [super init];
	if (self)
	{
		reloadDelay = 3.0f;
		view = [[WebView alloc] initWithFrame:NSMakeRect(0, 0, 4, 4)];
		[view setDrawsBackground:NO];
		[view setFrameLoadDelegate:self];
		[view setResourceLoadDelegate:self];
	}
	return self;
}

- (id)initWithHTML:(NSString *)HTML
{
	self = [self initWithHTML:HTML timeout:15.0f];
	if (self)
	{
	}
	return self;
}

- (id)initWithURL:(NSURL *)url
{
	self = [self initWithURL:url timeout:15.0f];
	if (self)
	{
	}
	return self;
}

- (id)initWithHTML:(NSString *)HTML timeout:(float)timeoutInterval
{
	self = [self init];
	if (self)
	{
		timeout = timeoutInterval;
		[self loadWithObject:HTML];
	}
	return self;
}

- (id)initWithURL:(NSURL *)url timeout:(float)timeoutInterval
{
	self = [self init];
	if (self)
	{
		timeout = timeoutInterval;
		[self loadWithObject:url];
	}
	return self;
}

- (void)dealloc
{
	[view release];
	[super dealloc];
}

- (void)checkTimeout
{
	if ([view isLoading])
		[self loadWithObject:nil];
}

- (void)loadWithObject:(id)object
{
	if (nil == object)
		[view reload:self];
	else if ([object isKindOfClass:[NSURL class]])
		[[view mainFrame] loadRequest:[NSURLRequest requestWithURL:object]];
	else if ([object isKindOfClass:[NSString class]])
		[[view mainFrame] loadHTMLString:object baseURL:nil];
	
	[self performSelector:@selector(checkTimeout) withObject:nil afterDelay:timeout];
}

- (void)webView:(WebView *)sender didClearWindowObject:(WebScriptObject *)windowScriptObject forFrame:(WebFrame *)frame
{
	script = windowScriptObject;
	
	if (delegate && [delegate respondsToSelector:@selector(jsReady:)])
		[delegate performSelector:@selector(jsReady:) withObject:nil afterDelay:0];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)webFrame
{
	// recalculate the size to fit content
	if ([webFrame isEqual:[view mainFrame]])
    {
        NSRect webFrameRect = [[[webFrame frameView] documentView] frame];
        [view setFrame:webFrameRect];
		
		if (delegate && [delegate respondsToSelector:@selector(frameLoaded:)])
			[delegate performSelector:@selector(frameLoaded:) withObject:nil];
    }
}

- (void)webView:(WebView *)sender resource:(id)identifier didFailLoadingWithError:(NSError *)error fromDataSource:(WebDataSource *)dataSource
{
	[view performSelector:@selector(reload:) withObject:self afterDelay:reloadDelay];
}

@end