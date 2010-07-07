//
//  CRChangeSignaler.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/7/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRChangeSignaler.h"

//////////////////////////////////////////////////////////////////////
// Change signaler
//////////////////////////////////////////////////////////////////////
@implementation CRChangeSignaler

- (id)initWithObject:(id)objectToObserve keyPath:(NSString *)aKeyPath target:(id)aTarget action:(SEL)anAction
{
	self = [super init];
	if (self)
	{
		object = objectToObserve;
		keyPath = aKeyPath;
		target = aTarget;
		action = anAction;
		
		[object addObserver:self forKeyPath:keyPath options:0 context:NULL];
	}
	return self;
}

- (void)dealloc
{
	[object removeObserver:self forKeyPath:keyPath];
	[super dealloc];
}

+ (id)signalWithObject:(id)objectToObserve keyPath:(NSString *)aKeyPath target:(id)aTarget action:(SEL)anAction
{
	return [[[self alloc] initWithObject:objectToObserve keyPath:aKeyPath target:aTarget action:anAction] autorelease];
}
			
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	[target performSelector:action withObject:self];
}

@end