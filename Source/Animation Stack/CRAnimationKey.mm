//
//  CRAnimationKey.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/14/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRAnimationKey.h"


//////////////////////////////////////////////////////////////////////
// Animation key (base class)
//////////////////////////////////////////////////////////////////////
@implementation CRAnimationKey

@synthesize root;
@synthesize duration;

- (id)initWithRoot:(CRAnimationStack *)aRoot duration:(NSTimeInterval)aDuration
{
	self = [super init];
	if (self)
	{
		root = aRoot;
		duration = aDuration;
	}
	return self;
}

- (void)run
{
}

@end

//////////////////////////////////////////////////////////////////////
// CAAnimation key
//////////////////////////////////////////////////////////////////////
@implementation CRCAAnimationKey

@synthesize target;
@dynamic	value;
@synthesize key;

- (void)dealloc
{
	[value release];
	[key release];
	[super dealloc];
}

- (id)value
{
	return value;
}

- (void)setValue:(id)aValue
{
	if (value != aValue)
	{
		[aValue retain];
		[value release];
		value = aValue;
	}
}

- (void)run
{
	//NSLog(@"Play key for %@.'%@' value '%@', duration %f", target, keyPath, value, duration);
	
	[[NSAnimationContext currentContext] setDuration:duration];
	[[target animator] setValue:value forKey:key];
	
	if (root)
	{
		if (duration > 0)
			[root performSelector:@selector(keyPlayed:) withObject:self afterDelay:duration];
		else
			[root performSelector:@selector(keyPlayed:) withObject:self];
	}
}

@end

//////////////////////////////////////////////////////////////////////
// NSAnimation key
//////////////////////////////////////////////////////////////////////
@implementation CRNSAnimationKey

@synthesize animation;

- (void)dealloc
{
	[animation release];
	[super dealloc];
}

- (void)run
{
	[animation setDuration:duration];
	[animation setDelegate:self];
	
	[animation startAnimation];
}

- (void)animationDidEnd:(NSAnimation *)animation
{
	if (root)
		[root performSelector:@selector(keyPlayed:) withObject:self];
}

@end