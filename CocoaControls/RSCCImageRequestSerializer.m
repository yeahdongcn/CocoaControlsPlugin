//
//  RSCCImageRequestSerializer.m
//  CocoaControls
//
//  Created by R0CKSTAR on 5/7/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

#import "RSCCImageRequestSerializer.h"

@implementation RSCCImageRequestSerializer

- (id)init
{
    self = [super init];
    if (self) {
        self.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    return self;
}

@end
