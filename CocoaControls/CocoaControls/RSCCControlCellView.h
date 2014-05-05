//
//  RSCCControlCellView.h
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-5.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RSCCControlCellView : NSTableCellView

@property (nonatomic, weak) IBOutlet NSTextField *titleField;

@property (nonatomic, weak) IBOutlet NSTextField *dateField;

@property (nonatomic, weak) IBOutlet NSTextField *licenseField;

@property (nonatomic, weak) IBOutlet NSButton *cocoaPodsButton;

@end
