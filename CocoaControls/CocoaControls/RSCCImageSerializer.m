//
//  RSCCImageSerializer.m
//  CocoaControls
//
//  Created by R0CKSTAR on 5/6/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

#import "RSCCImageSerializer.h"

@implementation RSCCImageSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSImage *image = [[NSImage alloc] initWithData:data];
    return image;
}

@end
