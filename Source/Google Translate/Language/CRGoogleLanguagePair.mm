//
//  CRGoogleLanguagePair.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/10/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRGoogleLanguagePair.h"

//////////////////////////////////////////////////////////////////////
// GoogleTranslate language pair
//////////////////////////////////////////////////////////////////////
@implementation CRGoogleLanguagePair

@synthesize	delegate;
@synthesize sourceLanguage;
@dynamic	destinationLanguage;

- (id)initWithSource:(CRGoogleLanguage *)source destination:(CRGoogleLanguage *)destination
{
	self = [super init];
	if (self)
	{
		self.sourceLanguage = source;
		self.destinationLanguage = destination;
	}
	return self;
}

+ (id)pairWithSource:(CRGoogleLanguage *)source destination:(CRGoogleLanguage *)destination
{
	return [[[self alloc] initWithSource:source destination:destination] autorelease];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self)
	{
		sourceLanguage = [[aDecoder decodeObjectForKey:@"source"] retain];
		destinationLanguage = [[aDecoder decodeObjectForKey:@"destination"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:sourceLanguage forKey:@"source"];
	[aCoder encodeObject:destinationLanguage forKey:@"destination"];
}

- (id)copyWithZone:(NSZone*)zone
{
	if (nil == zone)
		zone = NSDefaultMallocZone();
	
	CRGoogleLanguagePair* pair = [[[self class] allocWithZone:zone] init];
	pair->sourceLanguage = [sourceLanguage copyWithZone:zone];
	pair->destinationLanguage = [destinationLanguage copyWithZone:zone];
	return pair;
}

- (void)dealloc
{
	[sourceLanguage release];
	[destinationLanguage release];
	[super dealloc];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Properties

- (CRGoogleLanguage *)destinationLanguage
{
	return destinationLanguage;
}

- (void)setDestinationLanguage:(CRGoogleLanguage *)aLanguage
{
	if (destinationLanguage != aLanguage)
	{
		[aLanguage retain];
		[destinationLanguage release];
		destinationLanguage = aLanguage;
		
		if (delegate && [delegate respondsToSelector:@selector(pairDestinationChanged:)])
			[delegate performSelector:@selector(pairDestinationChanged:) withObject:self];
	}
}

@end