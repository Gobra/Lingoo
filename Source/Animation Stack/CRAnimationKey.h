//
//  CRAnimationKey.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/14/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

@class CRAnimationStack;

//////////////////////////////////////////////////////////////////////
// Stack key
//////////////////////////////////////////////////////////////////////
@interface CRAnimationKey : NSObject
{
	CRAnimationStack*	root;
	NSTimeInterval		duration;
}

@property (readonly) CRAnimationStack*	root;
@property (readonly) NSTimeInterval		duration;

- (id)initWithRoot:(CRAnimationStack *)aRoot duration:(NSTimeInterval)aDuration;

- (void)run;

@end

//////////////////////////////////////////////////////////////////////
// Stack key for CoreAnimation invocation
//////////////////////////////////////////////////////////////////////
@interface CRCAAnimationKey : CRAnimationKey
{
	id					target;
	id					value;
	NSString*			key;
}

@property (assign)	id			target;
@property (retain)	id			value;
@property (copy)	NSString*	key;

@end

//////////////////////////////////////////////////////////////////////
// Stack key for NSAnimation invocation
//////////////////////////////////////////////////////////////////////
@interface CRNSAnimationKey : CRAnimationKey
{
	NSAnimation* animation;
}

@property (retain)	NSAnimation*	animation;

@end