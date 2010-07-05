//
//  CRJSExec.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/5/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

//////////////////////////////////////////////////////////////////////
// JavaScript environment
//////////////////////////////////////////////////////////////////////
@interface CRJSExec : NSObject
{
	id					delegate;
	WebView*			view;
	WebScriptObject*	script;
}

@property (readonly)			WebView*			view;
@property (readonly)			WebScriptObject*	script;
@property (assign, readwrite)	id					delegate;

- (id)init;
- (id)initWithHTML:(NSString *)HTML;
- (id)initWithURL:(NSURL *)url;

@end