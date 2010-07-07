//
//  CRChangeSignaler.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

//////////////////////////////////////////////////////////////////////
// Change signaler
//////////////////////////////////////////////////////////////////////
@interface CRChangeSignaler : NSObject
{
	id			object;
	NSString*	keyPath;
	id			target;
	SEL			action;
}

- (id)initWithObject:(id)objectToObserve keyPath:(NSString *)aKeyPath target:(id)aTarget action:(SEL)anAction;
+ (id)signalWithObject:(id)objectToObserve keyPath:(NSString *)aKeyPath target:(id)aTarget action:(SEL)anAction;

@end