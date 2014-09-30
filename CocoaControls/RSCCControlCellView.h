//
//  RSCCControlCellView.h
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-5.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

extern int const  RSCCControlCellViewImageButtonTagBase,
                  RSCCControlCellViewCocoaPodsButtonTagBase,
                  RSCCControlCellViewCloneButtonTagBase;

extern CGFloat const  kCocoaPodsButtonWidthConstant,
                      kButtonsGapConstant;

@class RSCCControlCellViewBackgroundView;

@interface RSCCControlCellView : NSTableCellView

@property (assign) IBOutlet RSCCControlCellViewBackgroundView *backgroundView;

@property (assign) IBOutlet NSTextField *titleField, *dateField, *licenseField;

@property (assign) IBOutlet NSButton *imageButton, *cocoaPodsButton, *cloneButton;

@property (assign) IBOutlet NSImageView *star0, *star1, *star2, *star3, *star4;

@property (nonatomic) NSArray *stars;

@property (assign) IBOutlet NSLayoutConstraint *cocoaPodsButtonWidth, *buttonsGap;

@end
