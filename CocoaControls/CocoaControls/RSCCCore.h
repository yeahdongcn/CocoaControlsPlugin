//
//  RSCCCore.h
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-3.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>

#import "RSCCAPI.h"

#import "RSCCControl.h"

extern NSString *const RSCCCoreControlsDidLoadNotification;
extern NSString *const RSCCCoreDetailDidLoadNotification;

@interface RSCCCore : NSObject

@property (nonatomic, readonly) AFHTTPRequestOperationManager *imageManager;

+ (instancetype)sharedCore;

- (void)refreshControls;

- (void)moreControls;

- (void)detailForControl:(RSCCControl *)control withSender:(NSButton *)sender;

- (void)searchControlsWithKey:(NSString *)key;

@end
