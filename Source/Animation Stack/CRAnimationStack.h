//
//  CRAnimationStack.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/13/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

@class CRAnimationStack;

//////////////////////////////////////////////////////////////////////
// Stack key
//////////////////////////////////////////////////////////////////////
@interface CRAnimationKey : NSObject
{
	CRAnimationStack*	root;
	id					target;
	id					value;
	NSString*			key;
	NSTimeInterval		duration;
}

@property (assign)	CRAnimationStack*	root;
@property (assign)	id					target;
@property (retain)	id					value;
@property (copy)	NSString*			key;
@property (assign)	NSTimeInterval		duration;

- (void)run;

@end

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
- (void)appendAnimationForTarget:(id)target withValue:(id)value forKey:(NSString *)key withDuration:(NSTimeInterval)duration;

@end