//
//  RSCCControl.h
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-3.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSCCControl : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *license;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *link;

@property (nonatomic) BOOL isOnCocoaPods;

@property (nonatomic) CGFloat rating;

@property (nonatomic) int appsUsingThisControl;

- (instancetype)initWithAssignment:(void (^)(RSCCControl *))assignment;

@end
