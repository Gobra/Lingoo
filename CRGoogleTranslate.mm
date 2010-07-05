//
//  CRGoogleTranslate.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/5/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRGoogleTranslate.h"
#import "CRJSExec.h"

//////////////////////////////////////////////////////////////////////
// GoogleTranslate language
//////////////////////////////////////////////////////////////////////
@implementation CRGoogleLanguage : CRJSMapper

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

- (void)dealloc
{
	[languageCode release];
	[languageName release];
	[super dealloc];
}

@end

//////////////////////////////////////////////////////////////////////
// JavaScript based GoogleTranslate wrapper
//////////////////////////////////////////////////////////////////////
@implementation CRGoogleTranslate

@synthesize jsExec;

@dynamic	isReady;
@dynamic	languages;

- (id)init
{
	self = [super init];
	if (self)
	{
		isReady = NO;
		languages = [[NSArray alloc] init];
		
		// prepare JavaScript
		NSURL* docURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"GoogleTranslate" ofType:@"html"]];
		jsExec = [[CRJSExec alloc] initWithURL:docURL];
		[jsExec setDelegate:self];
	}
	return self;
}

//////////////////////////////////////////////////////////////////////
#pragma mark Auxilliary

- (NSArray *)cocoaArrayFromJavaArray:(id)javaArray mapperClass:(Class)mapperClass
{
	id lengthObject = [javaArray valueForKey:@"length"];
	int length = [lengthObject isKindOfClass:[NSNumber class]] ? [lengthObject intValue] : 0;
	NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:length];
	for (int i = 0; i < length; ++i)
	{
		id element = [javaArray webScriptValueAtIndex:i];
		if (element)
		{
			if ([element isKindOfClass:[WebScriptObject class]] && mapperClass)
				element = [[(CRJSMapper *)[mapperClass alloc] initWithWebScriptObject:element] autorelease];
			[result addObject:element];
		}
	}
	
	NSLog(@"%@", result);
	return [result autorelease];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Properties

- (BOOL)isReady
{
	return isReady;
}

- (void)setIsReady:(BOOL)flag
{
	isReady = flag;
}

- (NSArray *)languages
{
	return languages;
}

- (void)setLanguages:(id)array
{
	NSArray* cocoaArray = [array isKindOfClass:[NSArray class]]? array : [self cocoaArrayFromJavaArray:array mapperClass:[CRGoogleLanguage class]];
	
	if (languages != cocoaArray)
	{
		[cocoaArray retain];
		[languages release];
		languages = cocoaArray;
	}
}

//////////////////////////////////////////////////////////////////////
#pragma mark WebScripting

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)sel
{
	return YES;
}

+ (NSString *)webScriptNameForSelector:(SEL)sel
{
    return nil;
}

+ (BOOL)isKeyExcludedFromWebScript:(const char *)property
{
    if (strcmp(property, "isReady") == 0)
        return NO;
	if (strcmp(property, "languages") == 0)
		return NO;
    return YES;
}

+ (NSString *)webScriptNameForKey:(const char *)property
{
	if (strcmp(property, "isReady") == 0)
		return @"isReady";
	if (strcmp(property, "languages") == 0)
		return @"languages";
	return nil;
}

//////////////////////////////////////////////////////////////////////
#pragma mark JavaScript

- (void)initialize
{
}

//////////////////////////////////////////////////////////////////////
#pragma mark CRJSExec delegate

- (void)jsReady:(CRJSExec *)sender
{
	[[jsExec script] setValue:self forKey:@"root"];
}

@end