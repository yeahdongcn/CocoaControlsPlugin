//
//  RSCCControlCellView.m
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-5.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "RSCCControlCellView.h"

@interface RSCCControlCellViewBackgroundView : NSView

@end

@implementation RSCCControlCellViewBackgroundView

- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef context = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetRGBFillColor(context, 0.93f, 0.93f, 0.93f, 0.8f);
    CGContextFillRect(context, NSRectToCGRect(dirtyRect));
}

@end

@implementation RSCCControlCellView

- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle
{
}

@end
