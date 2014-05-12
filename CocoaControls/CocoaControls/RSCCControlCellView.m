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
    NSUInteger hexRGBA = 0xeeeeeeee;
    CGContextSetRGBFillColor(context, ((hexRGBA & 0xFF000000) >> 24), ((hexRGBA & 0x00FF0000) >> 16), ((hexRGBA & 0x0000FF00) >> 8), (hexRGBA & 0x000000FF) / 255.0f);
    CGContextFillRect(context, NSRectToCGRect(dirtyRect));
}

@end

int const RSCCControlCellViewImageButtonTagBase     = 1000;
int const RSCCControlCellViewCocoaPodsButtonTagBase = 2000;
int const RSCCControlCellViewCloneButtonTagBase     = 3000;

CGFloat const kCocoaPodsButtonWidthConstant         = 40.0f;
CGFloat const kButtonsGapConstant                   = 10.0f;

@implementation RSCCControlCellView

- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle
{
}

@end
