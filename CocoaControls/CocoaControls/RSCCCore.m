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
NSString *const RSCCCoreDetailDidLoadNotification   = @"com.pdq.core.control.detail.did.load";

@interface RSCCCore ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

@property (nonatomic, strong) AFHTTPRequestOperationManager *imageManager;

@property (nonatomic) int page;

@end

@implementation RSCCCore

- (void)RSCC_parseControlsWithDoc:(TFHpple *)doc
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *cs = [@[] mutableCopy];
        NSArray *elements  = [doc searchWithXPathQuery:@"//div[@class='control-grid-item']"];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:RSCCCoreControlsDidLoadNotification object:[NSArray arrayWithArray:cs] userInfo:@{@"page" : @(self.page)}];
        });
    });
}

- (void)RSCC_loadControlsWithURLString:(NSString *)URLString
{
    [self.requestManager.operationQueue cancelAllOperations];
    [self.imageManager.operationQueue cancelAllOperations];
    
    [self.requestManager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self RSCC_parseControlsWithDoc:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([error code] != NSURLErrorCancelled) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RSCCCoreControlsDidLoadNotification object:[NSArray arrayWithArray:nil] userInfo:@{@"page" : @(self.page)}];
        }
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
        
        self.filter = nil;
        
        [self refreshControls];
    }
    return self;
}

+ (instancetype)sharedCore
{
    static RSCCCore *sharedCore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCore = [self new];
    });
    return sharedCore;
}

- (void)refreshControls
{
    self.page = 1;
    
    NSString *URLString = self.filter ? [NSString stringWithFormat:@"%@&%@", self.filter, [NSString stringWithFormat:RSCCAPIPageFormat, self.page]] : [NSString stringWithFormat:@"%@?%@", RSCCAPIAllPlatform, [NSString stringWithFormat:RSCCAPIPageFormat, self.page]];
    
    [self RSCC_loadControlsWithURLString:URLString];
}

- (void)moreControls
{
    self.page += 1;
    
    NSString *URLString = self.filter ? [NSString stringWithFormat:@"%@&%@", self.filter, [NSString stringWithFormat:RSCCAPIPageFormat, self.page]] : [NSString stringWithFormat:@"%@?%@", RSCCAPIAllPlatform, [NSString stringWithFormat:RSCCAPIPageFormat, self.page]];
    
    [self RSCC_loadControlsWithURLString:URLString];
}

- (void)searchControlsWithKey:(NSString *)key
{
    self.page = 0;
    
    [self RSCC_loadControlsWithURLString:[[NSString stringWithFormat:RSCCAPISearchFormat, key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (void)detailForControl:(RSCCControl *)control withSender:(NSButton *)sender
{
    [self.requestManager.operationQueue cancelAllOperations];
    
    [self.requestManager GET:[NSString stringWithFormat:@"%@%@", RSCCAPIRoot, control.link] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *elements  = [responseObject searchWithXPathQuery:@"//*[@id=\"pod\"]"];
        if ([elements count] > 0) {
            TFHppleElement *pod = elements[0];
            control.pod = [pod attributes][@"value"];
        }
        
        elements = [responseObject searchWithXPathQuery:@"//*[@id=\"get_source_link\"]"];
        if ([elements count] > 0) {
            TFHppleElement *source = elements[0];
            control.source = [source attributes][@"href"];
        }
        
        if (control.pod || control.source) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RSCCCoreDetailDidLoadNotification object:control userInfo:@{@"sender" : sender}];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([error code] != NSURLErrorCancelled) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RSCCCoreDetailDidLoadNotification object:control userInfo:@{@"sender" : sender}];
        }
    }];
}

@end
