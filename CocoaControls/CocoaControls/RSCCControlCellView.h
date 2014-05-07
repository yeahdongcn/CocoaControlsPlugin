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

@class RSCCControlCellViewBackgroundView;

@interface RSCCControlCellView : NSTableCellView

@property (nonatomic, weak) IBOutlet RSCCControlCellViewBackgroundView *backgroundView;

@property (nonatomic, weak) IBOutlet NSButton *imageButton;

@property (nonatomic, weak) IBOutlet NSTextField *titleField;

@property (nonatomic, weak) IBOutlet NSTextField *dateField;

@property (nonatomic, weak) IBOutlet NSTextField *licenseField;

@property (nonatomic, weak) IBOutlet NSButton *cocoaPodsButton;

@property (nonatomic, weak) IBOutlet NSImageView *star0;

@property (nonatomic, weak) IBOutlet NSImageView *star1;

@property (nonatomic, weak) IBOutlet NSImageView *star2;

@property (nonatomic, weak) IBOutlet NSImageView *star3;

@property (nonatomic, weak) IBOutlet NSImageView *star4;

@property (nonatomic, strong) NSArray *stars;

@end
