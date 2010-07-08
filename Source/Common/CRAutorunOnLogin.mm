//
//  CRAutorunOnLogin.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 7/8/10.
//  Copyright 2010 Corner-A. All rights reserved.
//

#import "CRAutorunOnLogin.h"

//////////////////////////////////////////////////////////////////////
// Sets/Resets autorun item
//////////////////////////////////////////////////////////////////////
@implementation CRAutorunOnLogin

@dynamic startAtLogin;

- (id)initWithURL:(NSURL *)url
{
	self = [super init];
	if (self)
	{
		itemURL = [url copy];
	}
	return self;
}

- (void)dealloc
{
	[itemURL release];
	[super dealloc];
}

- (BOOL)startAtLogin
{
    Boolean foundIt = false;
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItems)
	{
        UInt32 seed = 0U;
        NSArray *currentLoginItems = [NSMakeCollectable(LSSharedFileListCopySnapshot(loginItems, &seed)) autorelease];
        for (id itemObject in currentLoginItems)
		{
            LSSharedFileListItemRef item = (LSSharedFileListItemRef)itemObject;
			
            UInt32 resolutionFlags = kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes;
            CFURLRef URL = NULL;
            OSStatus err = LSSharedFileListItemResolve(item, resolutionFlags, &URL, /*outRef*/ NULL);
            if (err == noErr) {
                foundIt = CFEqual(URL, itemURL);
                CFRelease(URL);
				
                if (foundIt)
                    break;
            }
        }
        CFRelease(loginItems);
    }
    return (BOOL)foundIt;
}

- (void)setStartAtLogin:(BOOL)enabled
{
    LSSharedFileListItemRef existingItem = NULL;
	
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItems)
	{
        UInt32 seed = 0U;
        NSArray *currentLoginItems = [NSMakeCollectable(LSSharedFileListCopySnapshot(loginItems, &seed)) autorelease];
        for (id itemObject in currentLoginItems)
		{
            LSSharedFileListItemRef item = (LSSharedFileListItemRef)itemObject;
			
            UInt32 resolutionFlags = kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes;
            CFURLRef URL = NULL;
            OSStatus err = LSSharedFileListItemResolve(item, resolutionFlags, &URL, /*outRef*/ NULL);
            if (err == noErr)
			{
                Boolean foundIt = CFEqual(URL, itemURL);
                CFRelease(URL);
				
                if (foundIt)
				{
                    existingItem = item;
                    break;
                }
            }
        }
		
        if (enabled && (existingItem == NULL))
		{
            LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemBeforeFirst,
                                          NULL, NULL, (CFURLRef)itemURL, NULL, NULL);
			
        }
		else if (!enabled && (existingItem != NULL))
            LSSharedFileListItemRemove(loginItems, existingItem);
		
        CFRelease(loginItems);
	}
}

@end