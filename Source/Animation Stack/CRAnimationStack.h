//
//  CRAnimationStack.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/13/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

//////////////////////////////////////////////////////////////////////
// AnimationStack
//////////////////////////////////////////////////////////////////////
@interface CRAnimationStack : NSObject
{
	BOOL			playing;
	NSMutableArray* stack;
	
	id				delegate;
}

@property (assign) id delegate;

- (void)reset;
- (void)playback;

// space
- (void)appendSpaceWithDuration:(NSTimeInterval)duration;

// core animation
- (void)appendAnimationForTarget:(id)target withValue:(id)value forKey:(NSString *)key duration:(NSTimeInterval)duration;

// nsanimation
- (void)appendNSAnimation:(NSAnimation *)animation;
- (void)appendNSAnimationWithTarget:(id)target frame:(NSRect)endFrame duration:(NSTimeInterval)duration;

@end