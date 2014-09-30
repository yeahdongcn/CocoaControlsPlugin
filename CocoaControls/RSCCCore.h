//
//  RSCCCore.h
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-3.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "AFNetworking.h"
#import "RSCCAPI.h"
#import "RSCCControl.h"

extern NSString *const RSCCCoreControlsDidLoadNotification,
                *const RSCCCoreDetailDidLoadNotification;

@interface RSCCCore : NSObject

@property (copy) NSString *filter;

@property (readonly) AFHTTPRequestOperationManager *imageManager;

+ (instancetype) sharedCore;

- (void) refreshControls;

- (void) moreControls;

- (void) detailForControl:(RSCCControl*)control withSender:(NSButton*)_;

- (void) searchControlsWithKey:(NSString*)key;

@end
