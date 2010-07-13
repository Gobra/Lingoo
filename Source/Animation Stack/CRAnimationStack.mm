//
//  CRAnimationStack.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/13/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRAnimationStack.h"

//////////////////////////////////////////////////////////////////////
// Animation key
//////////////////////////////////////////////////////////////////////
@implementation CRAnimationKey

@synthesize root;
@synthesize target;
@dynamic	value;
@synthesize key;
@synthesize duration;

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
// Animation stack
//////////////////////////////////////////////////////////////////////
@implementation CRAnimationStack

@synthesize delegate;

- (id)init
{
	self = [super init];
	if (self)
	{
		playing = NO;
		stack = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[stack release];
	[super dealloc];
}

- (void)reset
{
	playing = NO;
}

- (void)playback
{
	if (!playing && [stack count] > 0)
	{
		playing = YES;
		
		CRAnimationKey* key = [stack objectAtIndex:0];
		[key run];
	}
}

- (void)keyPlayed:(CRAnimationKey *)key
{
	if (playing)
	{
		// signal delegate the key is done
		if (delegate && [delegate respondsToSelector:@selector(animationKeyPlayed:)])
			[delegate performSelector:@selector(animationKeyPlayed:) withObject:key];
		
		// try to play next
		NSUInteger keyIndex = [stack indexOfObject:key];
		if (NSNotFound != keyIndex && keyIndex < [stack count]-1)
		{
			[[stack objectAtIndex:keyIndex + 1] run];
		}
		// signal the whole suquence is done
		else
		{
			// signal delegate the key is done
			if (delegate && [delegate respondsToSelector:@selector(animationStackPlayed:)])
				[delegate performSelector:@selector(animationStackPlayed:) withObject:self];
		}
	}
}

- (void)appendAnimationForTarget:(id)target withValue:(id)value forKey:(NSString *)key withDuration:(NSTimeInterval)duration
{
	CRAnimationKey* animKey = [[CRAnimationKey alloc] init];
	[animKey setTarget:target];
	[animKey setValue:value];
	[animKey setKey:key];
	[animKey setDuration:duration];
	[animKey setRoot:self];
	
	[stack addObject:animKey];
	[animKey release];
}

@end