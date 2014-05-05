//
//  RSControl.h
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-3.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSCCC : NSObject

@property (nonatomic, copy) NSString *stringTitle;

@property (nonatomic, copy) NSString *stringLicense;

@property (nonatomic, copy) NSString *stringDate;

@property (nonatomic, copy) NSString *stringImage;

@property (nonatomic, copy) NSString *stringLink;

@property (nonatomic) BOOL isOnCocoaPods;

@property (nonatomic) CGFloat rating;

@property (nonatomic) NSUInteger apps;

- (instancetype)initWithAssignment:(void (^)(RSCCC *))assignment;

@end
