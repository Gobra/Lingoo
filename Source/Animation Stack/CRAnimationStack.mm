//
//  CRAnimationStack.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/13/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRAnimationStack.h"
#import "CRAnimationKey.h"

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

- (void)appendSpaceWithDuration:(NSTimeInterval)duration
{
	[self appendAnimationForTarget:nil withValue:nil forKey:nil duration:duration];
}

- (void)appendAnimationForTarget:(id)target withValue:(id)value forKey:(NSString *)key duration:(NSTimeInterval)duration
{
	CRCAAnimationKey* animKey = [[CRCAAnimationKey alloc] initWithRoot:self duration:duration];
	[animKey setTarget:target];
	[animKey setValue:value];
	[animKey setKey:key];
	
	[stack addObject:animKey];
	[animKey release];
}

- (void)appendNSAnimation:(NSAnimation *)animation
{
	CRNSAnimationKey* animKey = [[CRNSAnimationKey alloc] initWithRoot:self duration:[animation duration]];
	[animKey setAnimation:animation];
	[stack addObject:animKey];
	
	[animKey release];
}

- (void)appendNSAnimationWithTarget:(id)target frame:(NSRect)endFrame duration:(NSTimeInterval)duration
{
	// NSAnimation
	NSDictionary* animData = [NSDictionary dictionaryWithObjectsAndKeys:
							  target,							NSViewAnimationTargetKey,
							  [NSValue valueWithRect:endFrame], NSViewAnimationEndFrameKey,
							  nil];
	
	NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:animData]];
	[animation setAnimationBlockingMode:NSAnimationNonblocking];
	
	// Key
	CRNSAnimationKey* animKey = [[CRNSAnimationKey alloc] initWithRoot:self duration:duration];
	[animKey setAnimation:animation];
	
	// Save and cleanup
	[stack addObject:animKey];
	[animKey release];
	[animation release];
}

@end