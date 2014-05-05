//
//  RSCCCore.h
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-3.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RSCCControl.h"

extern NSString *const RSCCCoreControlsDidLoadNotification;

@interface RSCCCore : NSObject

+ (instancetype)sharedCore;

- (void)moreControls;

@end
