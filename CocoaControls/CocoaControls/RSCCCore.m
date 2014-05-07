//
//  RSCCCore.m
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-3.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "RSCCCore.h"

#import "RSCCHTMLResponseSerializer.h"

#import "RSCCImageRequestSerializer.h"
#import "RSCCImageResponseSerializer.h"

#import <TFHpple.h>

NSString *const RSCCCoreControlsDidLoadNotification = @"com.pdq.core.controls.did.load";
NSString *const RSCCCorePodDidLoadNotification = @"com.pdq.core.control.pod.did.load";

@interface RSCCCore ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

@property (nonatomic, strong) AFHTTPRequestOperationManager *imageManager;

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
    [self.requestManager GET:[NSString stringWithFormat:RSCCAPIControlsAtPageFormat, self.currentPage] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *cs = [@[] mutableCopy];
            NSArray *elements  = [responseObject searchWithXPathQuery:@"//div[@class='control-grid-item']"];
            for (TFHppleElement *element in elements) {
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
                                    } else if ([component rangeOfString:@"Licensed"].length > 0 || [component rangeOfString:@"License"].length > 0) {
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
            dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:RSCCCoreControlsDidLoadNotification object:[NSArray arrayWithArray:cs] userInfo:nil];
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RSCCCoreControlsDidLoadNotification object:[NSArray arrayWithArray:nil] userInfo:nil];
    }];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:RSCCAPIRoot]];
        self.requestManager.responseSerializer = [RSCCHTMLResponseSerializer serializer];
        
        self.imageManager = [AFHTTPRequestOperationManager manager];
        self.imageManager.requestSerializer = [RSCCImageRequestSerializer serializer];
        self.imageManager.responseSerializer = [RSCCImageResponseSerializer serializer];
        
        [self refreshControls];
    }
    return self;
}

- (void)refreshControls
{
    self.currentPage = 1;
    
    [self loadControls];
}

- (void)moreControls
{
    self.currentPage += 1;
    
    [self loadControls];
}

- (void)podForControl:(RSCCControl *)control
{
    [self.requestManager GET:[NSString stringWithFormat:@"%@%@", RSCCAPIRoot, control.link] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *elements  = [responseObject searchWithXPathQuery:@"//*[@id=\"pod\"]"];
        if ([elements count] > 0) {
            TFHppleElement *pod = elements[0];
            control.pod = [pod attributes][@"value"];
            [[NSNotificationCenter defaultCenter] postNotificationName:RSCCCorePodDidLoadNotification object:control userInfo:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RSCCCorePodDidLoadNotification object:control userInfo:nil];
    }];
}

@end
