//
//  LOSpecialWindow.m
//  Lingoo
//
//  Created by Yaroslav Glushchenko on 10/26/09.
//  Copyright 2009 Corner-A. All rights reserved.
//

#import "LOSpecialWindow.h"

//////////////////////////////////////////////////////////////////////
// Translation panel
//////////////////////////////////////////////////////////////////////
@implementation LOSpecialWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)styleMask backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    if (self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag])
	{
        
        [self setBackgroundColor: [NSColor clearColor]];
        [self setAlphaValue:1.0];
        [self setOpaque:NO];
        [self setMovableByWindowBackground:YES];
		[self setLevel:NSFloatingWindowLevel];
        forceDisplay = NO;
        [self setBackgroundColor:[self sizedHUDBackground]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:self];
        return self;
    }
    return nil;
}

- (void)doClose
{
	[self orderOut:self];
	[self close];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResizeNotification object:self];    
    [super dealloc];
}

- (void)windowDidResize:(NSNotification *)aNotification
{
    [self setBackgroundColor:[self sizedHUDBackground]];
    if (forceDisplay)
        [self display];
}

- (void)setFrame:(NSRect)frameRect display:(BOOL)displayFlag animate:(BOOL)animationFlag
{
    forceDisplay = YES;
    [super setFrame:frameRect display:displayFlag animate:animationFlag];
    forceDisplay = NO;
}

- (NSColor *)sizedHUDBackground
{
    float alpha = 0.95;
    float titlebarHeight = 19.0;
    NSImage *bg = [[NSImage alloc] initWithSize:[self frame].size];
    [bg lockFocus];
    
    // Make background path
    NSRect bgRect = NSMakeRect(0, 0, [bg size].width, [bg size].height - titlebarHeight);
    int minX = NSMinX(bgRect);
    int midX = NSMidX(bgRect);
    int maxX = NSMaxX(bgRect);
    int minY = NSMinY(bgRect);
    int midY = NSMidY(bgRect);
    int maxY = NSMaxY(bgRect);
    float radius = 6.0;
    NSBezierPath *bgPath = [NSBezierPath bezierPath];
    
    // Bottom edge and bottom-right curve
    [bgPath moveToPoint:NSMakePoint(midX, minY)];
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(maxX, minY) 
                                     toPoint:NSMakePoint(maxX, midY) 
                                      radius:radius];
    
    [bgPath lineToPoint:NSMakePoint(maxX, maxY)];
    [bgPath lineToPoint:NSMakePoint(minX, maxY)];
    
    // Top edge and top-left curve
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(minX, maxY) 
                                     toPoint:NSMakePoint(minX, midY) 
                                      radius:radius];
    
    // Left edge and bottom-left curve
    [bgPath appendBezierPathWithArcFromPoint:bgRect.origin 
                                     toPoint:NSMakePoint(midX, minY) 
                                      radius:radius];
    [bgPath closePath];
    
    // Composite background color into bg
    [[NSColor colorWithCalibratedWhite:0.15 alpha:alpha] set];
    [bgPath fill];
    
    // Make titlebar path
    NSRect titlebarRect = NSMakeRect(0, [bg size].height - titlebarHeight, [bg size].width, titlebarHeight);
    minX = NSMinX(titlebarRect);
    midX = NSMidX(titlebarRect);
    maxX = NSMaxX(titlebarRect);
    minY = NSMinY(titlebarRect);
    midY = NSMidY(titlebarRect);
    maxY = NSMaxY(titlebarRect);
    NSBezierPath *titlePath = [NSBezierPath bezierPath];
    
    // Bottom edge and bottom-right curve
    [titlePath moveToPoint:NSMakePoint(minX, minY)];
    [titlePath lineToPoint:NSMakePoint(maxX, minY)];
    
    // Right edge and top-right curve
    [titlePath appendBezierPathWithArcFromPoint:NSMakePoint(maxX, maxY) 
										toPoint:NSMakePoint(midX, maxY) 
										 radius:radius];
    
    // Top edge and top-left curve
    [titlePath appendBezierPathWithArcFromPoint:NSMakePoint(minX, maxY) 
										toPoint:NSMakePoint(minX, minY) 
										 radius:radius];
    
    [titlePath closePath];
    
    // Titleba8
    NSGradient *titleGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.35 alpha:alpha] endingColor:[NSColor colorWithCalibratedWhite:0.15 alpha:alpha]];
    [titleGradient drawInBezierPath:titlePath angle:270.0];
	[titleGradient release];
    
    // Title
    NSFont *titleFont = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    [paraStyle setAlignment:NSCenterTextAlignment];
    [paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    NSMutableDictionary *titleAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   titleFont, NSFontAttributeName,
									   [NSColor whiteColor], NSForegroundColorAttributeName,
									   [[paraStyle copy] autorelease], NSParagraphStyleAttributeName,
									   nil];
    
    NSSize titleSize = [[self title] sizeWithAttributes:titleAttrs];
    // We vertically centre the title in the titlbar area, and we also horizontally 
    // inset the title by 19px, to allow for the 3px space from window's edge to close-widget, 
    // plus 13px for the close widget itself, plus another 3px space on the other side of 
    // the widget.
    NSRect titleRect = NSInsetRect(titlebarRect, 19.0, (titlebarRect.size.height - titleSize.height) / 2.0);
    [[self title] drawInRect:titleRect withAttributes:titleAttrs];
    [bg unlockFocus];
    
    return [NSColor colorWithPatternImage:[bg autorelease]];
}

- (void)setTitle:(NSString *)value
{
    [super setTitle:value];
    [self windowDidResize:nil];
}

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

@end
