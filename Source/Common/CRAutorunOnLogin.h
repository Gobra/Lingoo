//
//  CRAutorunOnLogin.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/8/10.
//  Copyright 2010 Corner-A. All rights reserved.
//


//////////////////////////////////////////////////////////////////////
// Sets/Resets autorun item
//////////////////////////////////////////////////////////////////////
@interface CRAutorunOnLogin : NSObject
{
	NSURL* itemURL;
}

@property (assign) BOOL startAtLogin;

- (id)initWithURL:(NSURL *)url;

@end