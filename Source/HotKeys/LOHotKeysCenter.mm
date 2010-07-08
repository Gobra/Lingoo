//
//  LOHotKeysCenter.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/8/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "LOHotKeysCenter.h"

#import "SGHotKey.h"
#import "SGHotKeyCenter.h"

//////////////////////////////////////////////////////////////////////
// HotKey info
//////////////////////////////////////////////////////////////////////
@implementation LOHotKeyInfo

@synthesize target;
@synthesize action;
@synthesize hotKey;

- (id)initWithKey:(SGHotKey *)aKey target:(id)aTarget action:(SEL)anAction
{
	self = [super init];
	if (self)
	{
		hotKey = aKey;
		target = aTarget;
		action = anAction;
	}
	return self;
}

+ (id)infoWithKey:(SGHotKey *)aKey target:(id)aTarget action:(SEL)anAction
{
	return [[[self alloc] initWithKey:aKey target:aTarget action:anAction] autorelease];
}

@end

//////////////////////////////////////////////////////////////////////
// HotKeys center
//////////////////////////////////////////////////////////////////////
static LOHotKeysCenter* gInstance = nil;

@implementation LOHotKeysCenter

- (id)init
{
	self = [super init];
	if (self)
	{
		converter = [[SRRecorderControl alloc] init];
		hotKeys = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[converter release];
	[hotKeys release];
	[super dealloc];
}

+ (id)sharedCenter
{
	if (nil == gInstance)
		gInstance = [[LOHotKeysCenter alloc] init];
	return gInstance;
}

- (KeyCombo)controlComboForKey:(NSString *)udKey
{
	id keyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:udKey];
	SGKeyCombo* keyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:keyComboPlist] autorelease];
	return SRMakeKeyCombo(keyCombo.keyCode, [converter carbonToCocoaFlags:keyCombo.modifiers]);
}

- (void)saveControlCombo:(KeyCombo)keyCombo forKey:(NSString *)udKey
{
	// Save new combo
	SGKeyCombo* sgKeyCombo = [SGKeyCombo keyComboWithKeyCode:keyCombo.code modifiers:[converter cocoaToCarbonFlags:keyCombo.flags]];
	[[NSUserDefaults standardUserDefaults] setObject:[sgKeyCombo plistRepresentation] forKey:udKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	// Re-register the key if needed
	LOHotKeyInfo* info = [hotKeys valueForKey:udKey];
	if (nil != info)
	{
		SGHotKey* hk = [info hotKey];
		[hk setKeyCombo:sgKeyCombo];
		[[SGHotKeyCenter sharedCenter] registerHotKey:hk];
	}
}

- (LOHotKeyInfo *)registerNewKey:(NSString *)udKey withTarget:(id)target action:(SEL)action
{
	id keyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:udKey];
	SGKeyCombo* keyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:keyComboPlist] autorelease];
	SGHotKey* key = [[[SGHotKey alloc] initWithIdentifier:udKey keyCombo:keyCombo target:target action:action] autorelease];
	
	return [LOHotKeyInfo infoWithKey:key target:target action:action];
}

- (void)registerHotkeyForKey:(NSString *)udKey withTarget:(id)target action:(SEL)action
{
	LOHotKeyInfo* info = [hotKeys valueForKey:udKey];
	if (nil == info)
	{
		info = [self registerNewKey:udKey withTarget:target action:action];
		[hotKeys setValue:info forKey:udKey];
	}
	
	// register & return
	[[SGHotKeyCenter sharedCenter] registerHotKey:[info hotKey]];
}

@end