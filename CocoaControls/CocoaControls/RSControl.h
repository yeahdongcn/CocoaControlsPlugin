//
//  RSControl.h
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-3.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSControl : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *license;

@property (nonatomic, copy) NSDate *date;

@property (nonatomic, copy) NSURL *imageURL;

@property (nonatomic) BOOL onCocoaPods;

@property (nonatomic) NSUInteger rating;

@end
