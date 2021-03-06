//
//  CRGoogleLanguage.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/6/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRGoogleLanguage.h"

//////////////////////////////////////////////////////////////////////
// GoogleTranslate language
//////////////////////////////////////////////////////////////////////
@implementation CRGoogleLanguage

@synthesize languageCode;
@synthesize languageName;

- (id)initWithWebScriptObject:(WebScriptObject *)wo
{
	self = [super init];
	if (self)
	{
		languageCode = [[wo valueForKey:@"code"] retain];
		
		// convert name to a readable format
		languageName = [[wo valueForKey:@"name"] capitalizedString];
		if ([languageName rangeOfString:@"_"].location != NSNotFound)
		{
			NSArray* components = [languageName componentsSeparatedByString:@"_"];
			if ([components count] == 2)
				languageName = [NSString stringWithFormat:@"%@ (%@)", [components objectAtIndex:0], [components objectAtIndex:1]];
		}
		[languageName retain];
	}
	return self;
}

- (id)initWithName:(NSString *)name code:(NSString *)code
{
	self = [super init];
	if (self)
	{
		languageName = [name copy];
		languageCode = [code copy];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self)
	{
		languageCode = [[aDecoder decodeObjectForKey:@"code"] retain];
		languageName = [[aDecoder decodeObjectForKey:@"name"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:languageCode forKey:@"code"];
	[aCoder encodeObject:languageName forKey:@"name"];
}

- (id)copyWithZone:(NSZone*)zone
{
	if (nil == zone)
		zone = NSDefaultMallocZone();
	
	CRGoogleLanguage* lang = [[[self class] allocWithZone:zone] init];
	lang->languageCode = [languageCode copyWithZone:zone];
	lang->languageName = [languageName copyWithZone:zone];
	return lang;
}

- (void)dealloc
{
	[languageCode release];
	[languageName release];
	[super dealloc];
}

- (NSString *)description
{
	return languageName;
}

//////////////////////////////////////////////////////////////////////
#pragma mark WebScripting

+ (BOOL)isKeyExcludedFromWebScript:(const char *)property
{
    if (strcmp(property, "languageCode") == 0)
        return NO;
	if (strcmp(property, "languageName") == 0)
		return NO;
    return YES;
}

+ (NSString *)webScriptNameForKey:(const char *)property
{
	if (strcmp(property, "languageCode") == 0)
		return @"languageCode";
	if (strcmp(property, "languageName") == 0)
		return @"languageName";
	return nil;
}

@end