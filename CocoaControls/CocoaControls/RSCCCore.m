//
//  RSCCCore.m
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-3.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "RSCCCore.h"

#import "RSCCAPI.h"

#import "RSCCHTMLSerializer.h"

#import <AFNetworking.h>

#import <TFHpple.h>

#import "RSCCControl.h"

NSString *const RSCCCoreControlsDidLoadNotification = @"com.pdq.core.controls.did.load";

@interface RSCCCore ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation RSCCCore

+ (instancetype)sharedCore
{
    static RSCCCore *sharedCore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCore = [self new];
    });
    return sharedCore;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:RSCCAPIRoot]];
        self.manager.responseSerializer = [RSCCHTMLSerializer serializer];
        [self.manager GET:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *cs = [@[] mutableCopy];
                for (TFHppleElement *element in responseObject) {
                    RSCCControl *c = [[RSCCControl alloc] initWithAssignment:^(RSCCControl *c) {
                        NSArray *spans = [element childrenWithTagName:@"span"];
                        [spans enumerateObjectsUsingBlock:^(TFHppleElement *span, NSUInteger idx, BOOL *stop) {
                            switch (idx) {
                                case 0: {
                                    
                                } break;
                                case 1: {
                                    NSArray *components = [span.text componentsSeparatedByString:@" • "];
                                    for (NSString *component in components) {
                                        if ([component rangeOfString:@"CocoaPod"].length > 0) {
                                            c.isOnCocoaPods = YES;
                                        } else if ([component rangeOfString:@"Licensed"].length > 0) {
                                            c.stringLicense = [component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                        } else if ([component rangeOfString:@"App"].length > 0){
                                            c.apps = [[[component substringToIndex:[component rangeOfString:@"App"].location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] integerValue];
                                        } else {
                                            c.stringDate = component;
                                        }
                                    }
                                } break;
                            }
                        }];
                    }];
                    [cs addObject:c];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:RSCCCoreControlsDidLoadNotification object:[NSArray arrayWithArray:cs] userInfo:nil];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
    return self;
}

@end
