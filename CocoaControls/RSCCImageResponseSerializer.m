//
//  RSCCImageResponseSerializer.m
//  CocoaControls
//
//  Created by R0CKSTAR on 5/6/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

#import "RSCCImageResponseSerializer.h"

@implementation RSCCImageResponseSerializer

- responseObjectForResponse:(NSURLResponse *)response
                       data:(NSData *)data
                      error:(NSError *__autoreleasing *)error
{
    return [NSImage.alloc initWithData:data];
}

@end
