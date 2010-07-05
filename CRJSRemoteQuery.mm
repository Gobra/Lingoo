//
//  CRJSRemoteQuery.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/6/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRJSRemoteQuery.h"

//////////////////////////////////////////////////////////////////////
// Remote Query params
//////////////////////////////////////////////////////////////////////
@implementation CRJSRemoteQueryParams

@synthesize data;

- (id)init
{
	return [self initWithDictionary:[NSDictionary dictionary]];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self)
	{
		data = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
	}
	return self;
}

- (void)dealloc
{
	[data release];
	[super dealloc];
}

- (id)valueForKey:(NSString *)key
{
	return [data valueForKey:key];
}

- (void)setValue:(id)value forKey:(NSString*)key
{
	[data setValue:value forKey:key];
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)sel
{
	if (sel == @selector(valueForKey:))
        return NO;
	if (sel == @selector(setValue:forKey:))
        return NO;
	return YES;
}

+ (NSString *)webScriptNameForSelector:(SEL)sel
{
	if (sel == @selector(valueForKey:))
        return @"valueForKey";
	if (sel == @selector(setValue:forKey:))
        return @"setValueForKey";
    return nil;
}

@end

//////////////////////////////////////////////////////////////////////
// Remote Query
//////////////////////////////////////////////////////////////////////
@implementation CRJSRemoteQuery

@synthesize target;
@synthesize completeAction;
@synthesize successStatus;
@synthesize params;

- (id)initWithTarget:(id)aTarget action:(SEL)anAction
{
	return [self initWithTarget:aTarget action:anAction params:[NSDictionary dictionary]];
}

- (id)initWithTarget:(id)aTarget action:(SEL)anAction params:(NSDictionary *)aParams
{
	self = [super init];
	if (self)
	{
		target = aTarget;
		completeAction = anAction;
		params = [[CRJSRemoteQueryParams alloc] initWithDictionary:aParams];
	}
	return self;
}

+ (id)queryWithTarget:(id)aTarget action:(SEL)anAction
{
	return [[[self alloc] initWithTarget:aTarget action:anAction] autorelease];
}

+ (id)queryWithTarget:(id)aTarget action:(SEL)anAction params:(NSDictionary *)aParams
{
	return [[[self alloc] initWithTarget:aTarget action:anAction params:aParams] autorelease];
}

- (void)complete:(BOOL)success
{
	successStatus = success;
	[target performSelector:completeAction withObject:self];
}

//////////////////////////////////////////////////////////////////////
#pragma mark WebScripting

+ (BOOL)isKeyExcludedFromWebScript:(const char *)property
{
    if (strcmp(property, "params") == 0)
        return NO;
    return YES;
}

+ (NSString *)webScriptNameForKey:(const char *)property
{
	if (strcmp(property, "params") == 0)
		return @"params";
	return nil;
}

@end