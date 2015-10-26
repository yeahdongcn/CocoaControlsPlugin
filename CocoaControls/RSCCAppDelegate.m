//
//  RSCCAppDelegate.m
//  CocoaControls
//
//  Created by R0CKSTAR on 14-5-2.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "RSCCAppDelegate.h"
#import "RSCCCore.h"
#import "RSCCControlCellView.h"
#import "ITPullToRefreshScrollView.h"

#import <CoreFoundation/CFNotificationCenter.h>

@interface RSCCAppDelegate () <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate, ITPullToRefreshScrollViewDelegate>

#pragma mark - Data

@property (nonatomic,) NSMutableArray *controls;
@property (nonatomic,copy) NSString *sort, *platform, *filterCocoaPods, *license, *oldSort, *oldPlatform, *oldFilterCocoaPods, *oldLicense;

@property (nonatomic) ITPullToRefreshEdge edge;

#pragma mark - Controls

@property (assign) IBOutlet ITPullToRefreshScrollView * scrollView;
@property (assign) IBOutlet NSImageView               * imageView;
@property (assign) IBOutlet NSPanel                   * imagePanel;
@property (assign) IBOutlet NSProgressIndicator       * progressIndicator;
@property (assign) IBOutlet NSSearchField             * searchField;
@property (assign) IBOutlet NSTableView               * tableView;
@property (assign) IBOutlet NSTextField               * label;
@property (assign) IBOutlet NSWindow                  * window;
@property (assign) IBOutlet NSPopover                 * popover,
                                                      * refreshPopover,
                                                      * morePopover;
@property (assign) IBOutlet NSButton                  * filterButton,
                                                      * sortButton,
                                                      * platformButton,
                                                      * filterCocoaPodsButton,
                                                      * licenseButton,
                                                      * refreshButton,
                                                      * moreButton;

@end

@implementation RSCCAppDelegate

#pragma mark - Refresh & more actions

- (void) RSCC_refresh {

    self.searchField.stringValue = @"";
    [self.controls removeAllObjects];
    [self.tableView      reloadData];
    
    [self.progressIndicator startAnimation:self];

    [CORE refreshControls];
}

- (void) RSCC_more {

    [self.progressIndicator startAnimation:self];

    [CORE moreControls];
}

#pragma mark - Refresh & more button click event handler

- (void) RSCC_handleRefreshButtonClicked:(NSButton *)sender {

    [self RSCC_refresh];
    [self.refreshPopover close];
}

- (void) RSCC_handleMoreButtonClicked:(NSButton *)sender {

    [self RSCC_more];
    [self.morePopover close];
}

#pragma mark - Filter changed handler

- (void) RSCC_handleFilterDidChange {

    [self.controls removeAllObjects];
    
    [self.tableView reloadData];
    
    [self.progressIndicator startAnimation:self];
    
    NSMutableString *mutableFilter = @"".mutableCopy;

    [self.platform isEqualToString:RSCCADPlatformDefault] ? ({
        [mutableFilter appendString:RSCCAPIAllPlatform];
        [mutableFilter appendString:@"?"];
    }) : ({
        [mutableFilter appendString:[NSString stringWithFormat:RSCCAPISinglePlatformFormat, [self.platform lowercaseString]]];
        [mutableFilter appendString:@"?"];
    });
    [self.sort isEqualToString:RSCCADSortDefault] ?: ({
        [mutableFilter appendString:[NSString stringWithFormat:RSCCAPISortFormat, [self.sort lowercaseString]]];
        [mutableFilter appendString:@"&"];
    });
    [self.filterCocoaPods isEqualToString:RSCCADFilterCocoaPodsDefault] ?: ({
        [mutableFilter appendString:[NSString stringWithFormat:RSCCAPICocoaPodsFormat, @"t"]];
        [mutableFilter appendString:@"&"];
    });
    [self.license isEqualToString:RSCCADLicenseDefault] ?: ({
        [mutableFilter appendString:[NSString stringWithFormat:RSCCAPILicenseFormat, [self.license stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [mutableFilter appendString:@"&"];
    });

    NSString *lastCharacter = [mutableFilter substringWithRange:NSMakeRange(mutableFilter.length - 1, 1)];

    CORE.filter = [lastCharacter isEqualToString:@"&"] ? [mutableFilter substringWithRange:NSMakeRange(0, mutableFilter.length - 1)]
                                                       : [NSString stringWithString:mutableFilter];
    
    [CORE refreshControls];
}

#pragma mark - Search handler

- (void) RSCC_handleSearch:(NSSearchField *)searchField {

    [self.controls removeAllObjects];
    [self.tableView reloadData];
    [self.progressIndicator startAnimation:self];
    
    NSString *key = searchField.stringValue;

    [key isEqualToString:@""] ? [CORE refreshControls] :  [CORE searchControlsWithKey:key];
}

#pragma mark - CORE notification handlers

- (void) RSCC_handleControlsDidLoad:(NSNotification *)aNotification {

    [self.progressIndicator stopAnimation:self];
    
    NSArray *controls = aNotification.object;
    [self.controls addObjectsFromArray:controls];
    
    if ([self.controls count] - [controls count] == 0) {
        [self.tableView reloadData];
    } else {
        [self.tableView beginUpdates];
        NSRange range = NSMakeRange([self.controls count] - [controls count], [controls count]);
        [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]
                              withAnimation:NSTableViewAnimationSlideDown];
        [self.tableView endUpdates];
    }
    
    if (self.edge & ITPullToRefreshEdgeTop || self.edge & ITPullToRefreshEdgeBottom) {
        [self.scrollView stopRefreshingEdge:self.edge];
        self.edge = ITPullToRefreshEdgeNone;
    }
}

- (void) RSCC_handleDetailDidLoad:(NSNotification *)aNotification {

    [self.progressIndicator stopAnimation:self];
    
    RSCCControl *c = aNotification.object;
    if ([(NSButton *)[aNotification userInfo][@"sender"] tag] >= RSCCControlCellViewCloneButtonTagBase) {
        if ([c.source rangeOfString:@"github"].length > 0
            || [c.source rangeOfString:@"bitbucket"].length > 0) {
            BOOL isOK = [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"github-mac://openRepo/%@", c.source]]];
            if (!isOK) {
                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:c.source]];
            }
        } else {
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:c.source]];
        }
    } else {
        self.label.stringValue = @"Pod info has been copied to clipboard.";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.label.stringValue = @"";
        });
        [[NSPasteboard generalPasteboard] clearContents];
        [[NSPasteboard generalPasteboard] setString:c.pod forType:NSStringPboardType];
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter() , CFSTR("com.pdq.rscccocoapods"), NULL, NULL, YES);
    }
}

#pragma mark - Popover buttons click event handlers

- (void) RSCC_handleSortButtonClicked:(NSButton *)sender {

    self.sort = sender.title;
}

- (void) RSCC_handlePlatformButtonClicked:(NSButton *)sender {

    NSString *title = sender.title;
    if ([title isEqualToString:@"OS X"]) {
        title = @"mac-os-x";
    }
    if (![self.platform isEqualToString:title]) {
        self.sort = RSCCADSortDefault;
        self.filterCocoaPods = RSCCADFilterCocoaPodsDefault;
        self.license = RSCCADLicenseDefault;
        
        self.sortButton.title = self.sort;
        self.filterCocoaPodsButton.title = self.filterCocoaPods;
        self.licenseButton.title = self.license;
    }
    self.platform = title;
}

- (void) RSCC_handleFilterCocoaPodsButtonClicked:(NSButton *)sender {

    self.filterCocoaPods = sender.title;
}

- (void) RSCC_handleLicenseButtonClicked:(NSButton *)sender {

    self.license = sender.title;
}

#pragma mark - CellView and button click event handlers

static int const RSCCADPreviewImageViewTagBase = 10000;

- (void) RSCC_handleButtonClick:(NSButton *)sender {

    if (sender.tag >= RSCCControlCellViewCloneButtonTagBase) {
        NSInteger row = sender.tag - RSCCControlCellViewCloneButtonTagBase;
        RSCCControl *c = self.controls[row];
        if (c.source) {
            [self RSCC_handleDetailDidLoad:[[NSNotification alloc] initWithName:RSCCCoreDetailDidLoadNotification object:c userInfo:@{@"sender" : sender}]];
        } else {
            [CORE detailForControl:c withSender:sender];
            [self.progressIndicator startAnimation:self];
        }
    } else if (sender.tag >= RSCCControlCellViewCocoaPodsButtonTagBase) {
        NSInteger row = sender.tag - RSCCControlCellViewCocoaPodsButtonTagBase;
        RSCCControl *c = self.controls[row];
        if (c.pod) {
            [self RSCC_handleDetailDidLoad:[[NSNotification alloc] initWithName:RSCCCoreDetailDidLoadNotification object:c userInfo:@{@"sender" : sender}]];
        } else {
            [CORE detailForControl:c withSender:sender];
            [self.progressIndicator startAnimation:self];
        }
    } else if (sender.tag >= RSCCControlCellViewImageButtonTagBase){
        NSInteger row = sender.tag - RSCCControlCellViewImageButtonTagBase;
        if (self.imageView.tag != (RSCCADPreviewImageViewTagBase + row)) {
            RSCCControl *c = self.controls[row];
            self.imageView.tag = RSCCADPreviewImageViewTagBase + row;
            self.imageView.image = nil;
            [CORE.imageManager GET:c.image parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                self.imageView.image = responseObject;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@", error);
            }];
            [self.imagePanel orderFront:self];
        }
    } else {
        if (self.filterButton.intValue == 1) {
            self.oldSort = self.sort;
            self.oldPlatform = self.platform;
            self.oldFilterCocoaPods = self.filterCocoaPods;
            self.oldLicense = self.license;
            [self.popover showRelativeToRect:[self.filterButton bounds]
                                      ofView:self.filterButton
                               preferredEdge:NSMaxYEdge];
        } else {
            [self.popover close];
            
            if (![self.sort isEqualToString:self.oldSort]
                || ![self.platform isEqualToString:self.oldPlatform]
                || ![self.filterCocoaPods isEqualToString:self.oldFilterCocoaPods]
                || ![self.license isEqualToString:self.oldLicense]) {
                [self RSCC_handleFilterDidChange];
            }
            
            self.oldSort = self.oldPlatform = self.oldFilterCocoaPods = self.oldLicense = nil;
        }
    }
}

- (void) RSCC_handleCellDoubleClick:(id)sender {

    RSCCControl *c = self.controls[self.tableView.clickedRow];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", RSCCAPIRoot, c.link]]];
}

#pragma mark - Getters

- (NSMutableArray *) controls { return _controls = _controls ?: @[].mutableCopy; }

#pragma mark - Getters for assigning default value

static NSString *const RSCCADSortDefault            = @"Date",
                *const RSCCADPlatformDefault        = @"All",
                *const RSCCADFilterCocoaPodsDefault = @"No",
                *const RSCCADLicenseDefault         = @"All";

- (NSString *) sort { return _sort = _sort ?: RSCCADSortDefault; }

- (NSString *) platform { return _platform = _platform ?: RSCCADPlatformDefault; }

- (NSString *) filterCocoaPods { return  _filterCocoaPods =  _filterCocoaPods ?: RSCCADFilterCocoaPodsDefault; }

- (NSString *) license { return  _license = _license ?: RSCCADLicenseDefault; }

#pragma mark - NSApplication

- (BOOL) applicationShouldOpenUntitledFile:(NSApplication *)sender {

    return [self.window makeKeyAndOrderFront:self], NO;
}

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification {

    // Insert code here to initialize your application
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(RSCC_handleControlsDidLoad:) name:RSCCCoreControlsDidLoadNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(RSCC_handleDetailDidLoad:) name:RSCCCoreDetailDidLoadNotification object:nil];
    
    [self.tableView setDoubleAction:@selector(RSCC_handleCellDoubleClick:)];
    
    [self.progressIndicator setDisplayedWhenStopped:NO];
    [self.progressIndicator startAnimation:self];
    
    self.searchField.action           = @selector(RSCC_handleSearch:);
    self.filterButton.action          = @selector(RSCC_handleButtonClick:);
    self.sortButton.action            = @selector(RSCC_handleSortButtonClicked:);
    self.platformButton.action        = @selector(RSCC_handlePlatformButtonClicked:);
    self.filterCocoaPodsButton.action = @selector(RSCC_handleFilterCocoaPodsButtonClicked:);
    self.licenseButton.action         = @selector(RSCC_handleLicenseButtonClicked:);
    self.refreshButton.action         = @selector(RSCC_handleRefreshButtonClicked:);
    self.moreButton.action            = @selector(RSCC_handleMoreButtonClicked:);

    [@[self.searchField, self.filterButton, self.sortButton, self.platformButton, self.filterCocoaPodsButton, self.licenseButton, self.refreshButton, self.moreButton]
      makeObjectsPerformSelector:@selector(setTarget:) withObject:self];

    [self.searchField becomeFirstResponder];
    
    self.scrollView.refreshableEdges = ITPullToRefreshEdgeTop | ITPullToRefreshEdgeBottom;
    self.scrollView.delegate = self;
}

#pragma mark - ITPullToRefreshScrollViewDelegate

- (void) pullToRefreshView:(ITPullToRefreshScrollView *)scrollView didReachRefreshingEdge:(ITPullToRefreshEdge)edge {

    switch (edge) {
        case ITPullToRefreshEdgeNone:
            if (self.refreshPopover.isShown) {
                [self.refreshPopover close];
            }
            if (self.morePopover.isShown) {
                [self.morePopover close];
            }
            break;
        case ITPullToRefreshEdgeTop:
            if (!self.refreshPopover.isShown) {
                [self.refreshPopover showRelativeToRect:CGRectMake(self.tableView.bounds.size.width - 2, 0, 2, 2)
                                                 ofView:self.tableView
                                          preferredEdge:NSMaxYEdge];
            }
            break;
        case ITPullToRefreshEdgeBottom:
            if (!self.morePopover.isShown) {
                [self.morePopover showRelativeToRect:CGRectMake(self.tableView.bounds.size.width - 2, self.tableView.bounds.size.height - 2, 2, 2)
                                              ofView:self.tableView
                                       preferredEdge:NSMaxYEdge];
            }
            break;
        default:
            break;
    }
}

- (void) pullToRefreshView:(ITPullToRefreshScrollView *)scrollView
   didStartRefreshingEdge:(ITPullToRefreshEdge)edge {

    if (edge & ITPullToRefreshEdgeTop) {
        [self RSCC_refresh];
    } else if ([self.searchField.stringValue length] == 0) {
        [self RSCC_more];
    }
    self.edge = edge;
}

#pragma mark - NSTableViewDataSource

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {

    return [self.controls count];
}

- (NSView *) tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    NSString *identifier = tableColumn.identifier;
    if ([identifier isEqualToString:@"ControlCell"]) {
        RSCCControlCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        cellView.imageButton.tag = RSCCControlCellViewImageButtonTagBase + row;
        cellView.cocoaPodsButton.tag = RSCCControlCellViewCocoaPodsButtonTagBase + row;
        cellView.cloneButton.tag = RSCCControlCellViewCloneButtonTagBase + row;
        if ([cellView.imageButton target] == nil) {
            [cellView.imageButton setTarget:self];
            [cellView.imageButton setAction:@selector(RSCC_handleButtonClick:)];
        }
        if ([cellView.cocoaPodsButton target] == nil) {
            [cellView.cocoaPodsButton setTarget:self];
            [cellView.cocoaPodsButton setAction:@selector(RSCC_handleButtonClick:)];
        }
        if ([cellView.cloneButton target] == nil) {
            [cellView.cloneButton setTarget:self];
            [cellView.cloneButton setAction:@selector(RSCC_handleButtonClick:)];
        }
        
        RSCCControl *c = self.controls[row];
        cellView.titleField.stringValue = c.title;
        cellView.licenseField.stringValue = c.license;
        cellView.dateField.stringValue = c.date;
        if (c.isOnCocoaPods) {
            cellView.cocoaPodsButtonWidth.constant  = kCocoaPodsButtonWidthConstant;
            cellView.buttonsGap.constant            = kButtonsGapConstant;
        } else {
            cellView.cocoaPodsButtonWidth.constant  =
            cellView.buttonsGap.constant            = 0;
        }
        cellView.stars = @[cellView.star0,
                           cellView.star1,
                           cellView.star2,
                           cellView.star3,
                           cellView.star4];
        [cellView.imageButton setImage:[NSImage imageNamed:@"placeholder"]];
        [CORE.imageManager GET:c.image parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [cellView.imageButton setImage:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [cellView.imageButton setImage:[NSImage imageNamed:@"placeholder"]];
            NSLog(@"%@", error);
        }];
        for (int i = 0; i < (int)c.rating; i++) {
            NSImageView *iv = cellView.stars[i];
            iv.image = [NSImage imageNamed:@"star"];
        }
        if (c.rating - (int)c.rating > 0) {
            NSImageView *iv = cellView.stars[(int)c.rating];
            iv.image = [NSImage imageNamed:@"star-half-o"];
        }
        return cellView;
    }
    return nil;
}

@end


int main(int argc, const char * argv[]) {

    CORE;
    return NSApplicationMain(argc, argv);
}
