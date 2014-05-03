//
//  RSAppDelegate.m
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-2.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "RSAppDelegate.h"

#import <AFRaptureXMLRequestOperation.h>
#import <RXMLElement.h>

@implementation RSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    AFRaptureXMLRequestOperation *operation = [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cocoacontrols.com/"]] success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
        [XMLElement iterateWithRootXPath:@"//div[@class='control-grid-item']" usingBlock: ^(RXMLElement *control) {
            
        }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
        // Handle Error
        NSLog(@"%@", XMLElement);
    }];
    
    [operation start];
}

@end
