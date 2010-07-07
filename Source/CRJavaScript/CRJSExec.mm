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

- (id)init
{
	self = [super init];
	if (self)
	{
		view = [[WebView alloc] init];
		[view setFrameLoadDelegate:self];
	}
	return self;
}

- (id)initWithHTML:(NSString *)HTML
{
	self = [self init];
	if (self)
	{
		[[view mainFrame] loadHTMLString:HTML baseURL:nil];
	}
	return self;
}

- (id)initWithURL:(NSURL *)url
{
	self = [self init];
	if (self)
	{
		[[view mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
	}
	return self;
}

- (void)dealloc
{
	[view release];
	[super dealloc];
}

- (void)webView:(WebView *)sender didClearWindowObject:(WebScriptObject *)windowScriptObject forFrame:(WebFrame *)frame
{
	script = windowScriptObject;
	
	if (delegate && [delegate respondsToSelector:@selector(jsReady:)])
		[delegate performSelector:@selector(jsReady:) withObject:nil afterDelay:0];
}

@end