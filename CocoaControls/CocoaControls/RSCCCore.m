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

@property (nonatomic) int currentPage;

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

- (void)loadControls
{
    [self.manager GET:[NSString stringWithFormat:RSCCAPIControlsAtPageFormat, self.currentPage] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *cs = [@[] mutableCopy];
            for (TFHppleElement *element in responseObject) {
                RSCCControl *c = [[RSCCControl alloc] initWithAssignment:^(RSCCControl *c) {
                    TFHppleElement *img = [[element firstChildWithTagName:@"a"] firstChildWithTagName:@"img"];
                    c.image = [img attributes][@"src"];
                    
                    NSArray *is = [[element firstChildWithTagName:@"div"] childrenWithTagName:@"i"];
                    for (TFHppleElement *i in is) {
                        NSString *class = [i attributes][@"class"];
                        if ([class isEqualToString:@"icon-star"]) {
                            c.rating += 1;
                        } else if ([class isEqualToString:@"icon-star-half-full"]) {
                            c.rating += 0.5;
                        }
                    }
                    
                    NSArray *spans = [element childrenWithTagName:@"span"];
                    [spans enumerateObjectsUsingBlock:^(TFHppleElement *span, NSUInteger idx, BOOL *stop) {
                        switch (idx) {
                            case 0: {
                                TFHppleElement *a = [span firstChildWithTagName:@"a"];
                                c.title = a.text;
                                c.link = [a attributes][@"href"];
                            } break;
                            case 1: {
                                NSArray *components = [span.text componentsSeparatedByString:@" • "];
                                for (NSString *component in components) {
                                    if ([component rangeOfString:@"CocoaPod"].length > 0) {
                                        c.isOnCocoaPods = YES;
                                    } else if ([component rangeOfString:@"Licensed"].length > 0) {
                                        c.license = [component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                    } else if ([component rangeOfString:@"App"].length > 0){
                                        c.appsUsingThisControl = [[[component substringToIndex:[component rangeOfString:@"App"].location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
                                    } else {
                                        c.date = component;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:RSCCCoreControlsDidLoadNotification object:[NSArray arrayWithArray:nil] userInfo:nil];
    }];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.currentPage = 1;
        
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:RSCCAPIRoot]];
        self.manager.responseSerializer = [RSCCHTMLSerializer serializer];
        
        [self loadControls];
    }
    return self;
}

- (void)moreControls
{
    self.currentPage += 1;
    
    [self loadControls];
}

@end
