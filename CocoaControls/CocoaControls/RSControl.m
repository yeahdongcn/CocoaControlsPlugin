//
//  RSControl.m
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-3.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "RSControl.h"

@implementation RSControl

- (instancetype)initWithAssignment:(void (^)(RSControl *))assignment
{
    self = [super init];
    if (self) {
        if (assignment) {
            assignment(self);
        }
    }
    return self;
}

@end
