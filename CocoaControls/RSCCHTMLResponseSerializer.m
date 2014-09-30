//
//  RSCCHTMLResponseSerializer.m
//  CocoaControls
//
//  Created by R0CKSTAR on 5/5/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

#import "RSCCHTMLResponseSerializer.h"

#import "TFHpple.h"

@implementation RSCCHTMLResponseSerializer

- responseObjectForResponse:(NSURLResponse *)response
                       data:(NSData *)data
                      error:(NSError *__autoreleasing *)error {

  return [TFHpple.alloc initWithHTMLData:data];
}

@end
