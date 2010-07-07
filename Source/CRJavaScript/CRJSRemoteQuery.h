//
//  CRJSRemoteQuery.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/6/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

//////////////////////////////////////////////////////////////////////
// Remote Query params
//////////////////////////////////////////////////////////////////////
@interface CRJSRemoteQueryParams : NSObject
{
	NSMutableDictionary* data;
}

@property (readonly) NSDictionary* data;

- (id)init;
- (id)initWithDictionary:(NSDictionary *)dictionary;

- (id)valueForKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString*)key;

@end

//////////////////////////////////////////////////////////////////////
// Remote Query
//////////////////////////////////////////////////////////////////////
@interface CRJSRemoteQuery : NSObject
{
	id						target;
	SEL						completeAction;
	BOOL					successStatus;
	CRJSRemoteQueryParams*	params;
}

@property (readonly) id						target;
@property (readonly) SEL					completeAction;
@property (readonly) BOOL					successStatus;
@property (readonly) CRJSRemoteQueryParams*	params;

- (id)initWithTarget:(id)aTarget action:(SEL)anAction;
- (id)initWithTarget:(id)aTarget action:(SEL)anAction params:(NSDictionary *)aParams;

+ (id)queryWithTarget:(id)aTarget action:(SEL)anAction;
+ (id)queryWithTarget:(id)aTarget action:(SEL)anAction params:(NSDictionary *)aParams;

- (void)complete:(BOOL)success;

@end