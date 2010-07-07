//
//  CRGoogleTranslate.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/5/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRGoogleTranslate.h"

NSString* const CRGoogleTranslateTextKey = @"text";
NSString* const CRGoogleTranslateLanguageCodeKey = @"langCode";
NSString* const CRGoogleTranslateSourceLanguageCodeKey = @"srcLang";
NSString* const CRGoogleTranslateDestinationLanguageCodeKey = @"dstLang";
NSString* const CRGoogleTranslateTranslationKey = @"translation";

//////////////////////////////////////////////////////////////////////
// JavaScript based GoogleTranslate wrapper
//////////////////////////////////////////////////////////////////////
@implementation CRGoogleTranslate

@synthesize jsExec;

@dynamic	isReady;
@dynamic	isWaiting;
@dynamic	languages;

- (id)init
{
	self = [super init];
	if (self)
	{
		isReady = NO;
		isWaiting = YES;
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
	
	return [result autorelease];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Properties

- (BOOL)isWaiting
{
	return isWaiting;
}

- (void)setIsWaiting:(BOOL)flag
{
	isWaiting = flag;
}

- (BOOL)isReady
{
	return isReady;
}

- (void)setIsReady:(BOOL)flag
{
	isReady = flag;
	self.isWaiting = NO;
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
#pragma mark Parsing

- (CRGoogleLanguage *)defaultLanguage
{
	return [self languageFromCode:@"en"];
}

- (CRGoogleLanguage *)languageFromCode:(NSString *)languageCode
{
	if (languageCode)
	{
		for (CRGoogleLanguage* language in [self languages])
		{
			if ([[language languageCode] isEqualToString:languageCode])
				return language;
		}
	}
	
	return nil;
}

- (CRGoogleLanguage *)languageFromQuery:(CRJSRemoteQuery *)query
{
	NSString* languageCode = [[query params] valueForKey:CRGoogleTranslateLanguageCodeKey];
	return [self languageFromCode:languageCode];
}

//////////////////////////////////////////////////////////////////////
#pragma mark Google Translate

- (void)signalQueryComplete:(CRJSRemoteQuery *)query
{
	[query complete:YES];
	self.isWaiting = NO;
}

- (void)callMethod:(NSString *)methodName withQuery:(CRJSRemoteQuery *)query
{
	self.isWaiting = YES;
	[[jsExec script] callWebScriptMethod:methodName withArguments:[NSArray arrayWithObject:query]];
}

- (void)detectLanguage:(CRJSRemoteQuery *)query
{
	[self callMethod:@"detectLanguage" withQuery:query];
}

- (void)translateText:(CRJSRemoteQuery *)query
{
	[self callMethod:@"translateText" withQuery:query];
}

//////////////////////////////////////////////////////////////////////
#pragma mark WebScripting

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)sel
{
	if (sel == @selector(signalQueryComplete:))
		return NO;
	return YES;
}

+ (NSString *)webScriptNameForSelector:(SEL)sel
{
	if (sel == @selector(signalQueryComplete:))
		return @"signalQueryComplete";
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