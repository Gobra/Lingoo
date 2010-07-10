//
//  CRDataToObjectTransformer.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/10/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRDataToObjectTransformer.h"

//////////////////////////////////////////////////////////////////////
// Value transformer, converts objects <-> NSData
//////////////////////////////////////////////////////////////////////
@implementation CRDataToObjectTransformer

+ (id)transformer;
{
	return [[[self alloc] init] autorelease];
}

+ (Class)transformedValueClass
{
	return [NSData class];
}

+ (BOOL)allowsReverseTransformation
{
	return YES;
}

- (BOOL)checkValue:(id)value
{
	return [value isKindOfClass:[NSData class]];
}

- (id)transformedValue:(id)value
{
	return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

- (id)reverseTransformedValue:(id)value
{
	return [NSKeyedArchiver archivedDataWithRootObject:value];
}

@end