//
//  CRGoogleLanguagePairsSet.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/10/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRGoogleLanguagePairsSet.h"
#import "CRGoogleLanguagePair.h"

NSString* const CRLanguagePairAnyLanguageMarker = @"CRLanguagePairAnyLanguageMarker";

//////////////////////////////////////////////////////////////////////
// GoogleTranslate language pair set
//////////////////////////////////////////////////////////////////////
@implementation CRGoogleLanguagePairsSet

@synthesize	translator;
@synthesize autosaveName;
@synthesize pairs;
@synthesize unusedSourceLanguages;

- (id)init
{
	self = [super init];
	if (self)
	{
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self)
	{
		pairs = [[aDecoder decodeObjectForKey:@"pairs"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:pairs forKey:@"pairs"];
}

- (id)copyWithZone:(NSZone*)zone
{
	if (nil == zone)
		zone = NSDefaultMallocZone();
	
	CRGoogleLanguagePairsSet* set = [[[self class] allocWithZone:zone] init];
	set.translator = self.translator;
	set->autosaveName = [autosaveName copyWithZone:zone];
	set->pairs = [pairs copyWithZone:zone];
	return set;
}

- (void)dealloc
{
	[autosaveName release];
	[pairs release];
	[unusedSourceLanguages release];
	[super dealloc];
}

+ (id)defaultData
{
	return [NSKeyedArchiver archivedDataWithRootObject:[NSMutableArray array]];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Properties

- (CRGoogleLanguagePair *)pairSourceForCode:(NSString *)code
{
	for (CRGoogleLanguagePair* pair in pairs)
		if ([[[pair sourceLanguage] languageCode] isEqualToString:code])
			return pair;
	return nil;
}

- (void)updateUnusedLanguages
{
	// "Any" language marker
	NSMutableArray* result = [NSMutableArray array];
	if (nil == [self targetLanguageForAnyMarker])
	{
		CRGoogleLanguage* marker = [[CRGoogleLanguage alloc] initWithName:NSLocalizedString(@"language.any_marker", @"") code:CRLanguagePairAnyLanguageMarker];
		[result addObject:marker];
		[marker release];
	}
	
	// Languages
	for (CRGoogleLanguage* language in [translator languages])
	{
		if (nil == [self pairSourceForCode:[language languageCode]] && ![[language languageCode] isEqualToString:@""]) // empty string is 'Unknown'
			[result addObject:language];
	}
	
	// Set and signal
	[self willChangeValueForKey:@"unusedSourceLanguages"];
	unusedSourceLanguages = [result retain];
	[self didChangeValueForKey:@"unusedSourceLanguages"];
}

- (void)setTranslator:(CRGoogleTranslate *)aTranslate
{
	if (translator != aTranslate)
	{
		translator = aTranslate;
		[self updateUnusedLanguages];
	}
}

- (void)setPairs:(NSArray *)array
{
	if (pairs != array)
	{
		[array retain];
		[pairs release];
		pairs = array;
		
		[self updateUnusedLanguages];
		for (CRGoogleLanguagePair* pair in pairs)
			[pair setDelegate:self];
	}
}

//////////////////////////////////////////////////////////////////////
#pragma mark Methods

- (void)readFromDefaults
{
	if (autosaveName)
	{
		NSData* data = [[NSUserDefaults standardUserDefaults] valueForKey:autosaveName];
		if (nil != data)
			self.pairs = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
}

- (void)flushToDefaults
{
	if (autosaveName)
	{
		NSData* lpData = [NSKeyedArchiver archivedDataWithRootObject:pairs];
		[[NSUserDefaults standardUserDefaults] setValue:lpData forKey:LOLanguagePairsKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)pairDestinationChanged:(CRGoogleLanguagePair *)pair
{
	[self flushToDefaults];
}

- (void)addDestination:(CRGoogleLanguage *)destinationLanguage forSource:(CRGoogleLanguage *)sourceLanguage
{
	if ([unusedSourceLanguages containsObject:sourceLanguage])
	{
		// create pair
		CRGoogleLanguagePair* pair = [CRGoogleLanguagePair pairWithSource:sourceLanguage destination:destinationLanguage];
		[pair setDelegate:self];
		
		// set new data
		[self willChangeValueForKey:@"unusedSourceLanguages"];
		self.pairs = [pairs arrayByAddingObject:pair];
		[unusedSourceLanguages removeObject:sourceLanguage];
		[self flushToDefaults];
		[self willChangeValueForKey:@"unusedSourceLanguages"];
	}
}

- (void)removePair:(CRGoogleLanguagePair *)pair
{
	// "array by removing object"
	NSMutableArray* result = [NSMutableArray arrayWithCapacity:[pairs count] - 1];
	for (id storedPair in pairs)
		if (pair != storedPair)
			[result addObject:storedPair];
	
	// assign
	self.pairs = [NSArray arrayWithArray:result];
	[self flushToDefaults];
}

- (void)removePairForSource:(CRGoogleLanguage *)sourceLanguage
{
	CRGoogleLanguagePair* found = [self pairSourceForCode:[sourceLanguage languageCode]];
	if (nil != found)
		[self removePair:found];
}

- (CRGoogleLanguage *)targetLanguageForAnyMarker
{
	return [[self pairSourceForCode:CRLanguagePairAnyLanguageMarker] destinationLanguage];
}

- (CRGoogleLanguage *)destinationLanguageForSource:(NSString *)sourceCode
{
	CRGoogleLanguagePair* pair = [self pairSourceForCode:sourceCode];
	if (nil == pair)
		pair = [self pairSourceForCode:CRLanguagePairAnyLanguageMarker];
	return [pair destinationLanguage];
	
}

@end