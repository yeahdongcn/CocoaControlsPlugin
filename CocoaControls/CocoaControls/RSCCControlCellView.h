//
//  RSCCControlCellView.h
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-5.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern int const RSCCControlCellViewImageButtonTagBase;
extern int const RSCCControlCellViewCocoaPodsButtonTagBase;
extern int const RSCCControlCellViewCloneButtonTagBase;

@class RSCCControlCellViewBackgroundView;

@interface RSCCControlCellView : NSTableCellView

@property (assign) IBOutlet RSCCControlCellViewBackgroundView *backgroundView;

@property (assign) IBOutlet NSButton *imageButton;

@property (assign) IBOutlet NSTextField *titleField;

@property (assign) IBOutlet NSTextField *dateField;

@property (assign) IBOutlet NSTextField *licenseField;

@property (assign) IBOutlet NSButton *cocoaPodsButton;

@property (assign) IBOutlet NSButton *cloneButton;

@property (assign) IBOutlet NSImageView *star0;

@property (assign) IBOutlet NSImageView *star1;

@property (assign) IBOutlet NSImageView *star2;

@property (assign) IBOutlet NSImageView *star3;

@property (assign) IBOutlet NSImageView *star4;

@property (nonatomic, strong) NSArray *stars;

@end
