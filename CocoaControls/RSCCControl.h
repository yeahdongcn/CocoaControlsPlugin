//
//  RSCCControl.h
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-3.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSCCControl : NSObject

@property (copy) NSString *title, *license, *date, *image, *link, *pod, *source;

@property (nonatomic) BOOL isOnCocoaPods;

@property (nonatomic) CGFloat rating;

@property (nonatomic) int appsUsingThisControl;

- initWithAssignment:(void (^)(RSCCControl *))assignment;

@end
