//
//  RSCCImageRequestSerializer.m
//  CocoaControls
//
//  Created by R0CKSTAR on 5/7/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

#import "RSCCImageRequestSerializer.h"

@implementation RSCCImageRequestSerializer

- init { return super.init ? self.cachePolicy = NSURLRequestReturnCacheDataElseLoad, self : nil; }

@end
