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

#import "RSDataCenter.h"

@implementation RSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    AFRaptureXMLRequestOperation *operation = [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cocoacontrols.com/"]] success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
        
        [XMLElement iterateWithRootXPath:@"//i']" usingBlock: ^(RXMLElement *a) {
            NSLog(@"%@", a);
        }];
         
        [XMLElement iterateWithRootXPath:@"//div[@class='control-grid-item']" usingBlock: ^(RXMLElement *control_grid_item) {
            RSControl *control = [[RSControl alloc] initWithAssignment:^(RSControl *c) {
                c.stringTitle = [control_grid_item child:@"span.a"].text;
                c.stringLink  = [[control_grid_item child:@"span.a"] attribute:@"href"];
                c.stringImage = [[control_grid_item child:@"a.img"] attribute:@"src"];
                NSArray *components = [[control_grid_item child:@"br.span"].text componentsSeparatedByString:@" • "];
                for (NSString *component in components) {
                    if ([component rangeOfString:@"CocoaPod"].length > 0) {
                        c.isOnCocoaPods = YES;
                    } else if ([component rangeOfString:@"Licensed"].length > 0) {
                        c.stringLicense = component;
                    } else if ([component rangeOfString:@"App"].length > 0){
                        c.apps = [[[component substringToIndex:[component rangeOfString:@"App"].location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] integerValue];
                    } else {
                        c.stringDate = component;
                    }
                }
                
                NSArray *stars = [control_grid_item children:@"br.div.i"];
                CGFloat rating = 0;
                for (RXMLElement *star in stars) {
                    if ([[star attribute:@"class"] isEqualToString:@"icon-star"]) {
                        rating += 1;
                    } else if ([[star attribute:@"class"] isEqualToString:@"icon-star-half-full"]) {
                        rating += 0.5;
                    }
                }
                c.rating = rating;
                int a = 0;
                a++;
            }];
        }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
        // Handle Error
        NSLog(@"%@", XMLElement);
    }];
    
    [operation start];
}

@end
