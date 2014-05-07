//
//  RSCCA.m
//  CocoaControls
//
//  Created by R0CKSTAR on 5/5/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

#import "RSCCHTMLSerializer.h"

#import <TFHpple.h>

@implementation RSCCHTMLSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    return   doc;
}

@end
