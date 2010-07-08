//
//  LOHotKeysCenter.h
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/8/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "SGHotKey.h"
#import "SGKeyCombo.h"

//////////////////////////////////////////////////////////////////////
// HotKey info
//////////////////////////////////////////////////////////////////////
@interface LOHotKeyInfo : NSObject
{
	id			target;
	SEL			action;
	SGHotKey*	hotKey;
}

@property (readonly) id			target;
@property (readonly) SEL		action;
@property (readonly) SGHotKey*	hotKey;

- (id)initWithKey:(SGHotKey *)aKey target:(id)aTarget action:(SEL)anAction;
+ (id)infoWithKey:(SGHotKey *)aKey target:(id)aTarget action:(SEL)anAction;

@end

//////////////////////////////////////////////////////////////////////
// HotKeys center: a wrapper around SGHotKeyCenter with UserDefaults
// orientation
//////////////////////////////////////////////////////////////////////
@interface LOHotKeysCenter : NSObject
{
	SRRecorderControl*		converter;
	NSMutableDictionary*	hotKeys;
}

+ (id)sharedCenter;

- (KeyCombo)controlComboForKey:(NSString *)udKey;
- (void)saveControlCombo:(KeyCombo)keyCombo forKey:(NSString *)udKey;
- (void)registerHotkeyForKey:(NSString *)udKey withTarget:(id)target action:(SEL)action;

@end