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

@interface RSCCAppDelegate () <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>

#pragma mark - Data

@property (nonatomic, strong) NSMutableArray *controls;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *platform;

@property (nonatomic, copy) NSString *filterCocoaPods;

@property (nonatomic, copy) NSString *license;

@property (nonatomic, copy) NSString *oldSort;

@property (nonatomic, copy) NSString *oldPlatform;

@property (nonatomic, copy) NSString *oldFilterCocoaPods;

@property (nonatomic, copy) NSString *oldLicense;

#pragma mark - Controls

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, weak) IBOutlet NSSearchField *searchField;

@property (nonatomic, weak) IBOutlet NSTableView *tableView;

@property (nonatomic, weak) IBOutlet NSProgressIndicator *progressIndicator;

@property (nonatomic, weak) IBOutlet NSPanel *imagePanel;

@property (nonatomic, weak) IBOutlet NSImageView *imageView;

@property (nonatomic, weak) IBOutlet NSButton *filterButton;

@property (nonatomic, weak) IBOutlet NSPopover *popover;

@property (nonatomic, weak) IBOutlet NSButton *sortButton;

@property (nonatomic, weak) IBOutlet NSButton *platformButton;

@property (nonatomic, weak) IBOutlet NSButton *filterCocoaPodsButton;

@property (nonatomic, weak) IBOutlet NSButton *licenseButton;

@end

@implementation RSCCAppDelegate

- (void)RSCC_handleFilterDidChange
{
    [self.controls removeAllObjects];
    
    [self.tableView reloadData];
    
    [self.progressIndicator startAnimation:self];
    
    NSMutableString *mutableFilter = [@"" mutableCopy];
    if ([self.platform isEqualToString:RSCCADPlatformDefault]) {
        [mutableFilter appendString:RSCCAPIAllPlatform];
        [mutableFilter appendString:@"?"];
    } else {
        [mutableFilter appendString:[NSString stringWithFormat:RSCCAPISinglePlatformFormat, [self.platform lowercaseString]]];
        [mutableFilter appendString:@"?"];
    }
    if (![self.sort isEqualToString:RSCCADSortDefault]) {
        [mutableFilter appendString:[NSString stringWithFormat:RSCCAPISortFormat, [self.sort lowercaseString]]];
        [mutableFilter appendString:@"&"];
    }
    if (![self.filterCocoaPods isEqualToString:RSCCADFilterCocoaPodsDefault]) {
        [mutableFilter appendString:[NSString stringWithFormat:RSCCAPICocoaPodsFormat, @"t"]];
        [mutableFilter appendString:@"&"];
    }
    if (![self.license isEqualToString:RSCCADLicenseDefault]) {
        [mutableFilter appendString:[NSString stringWithFormat:RSCCAPILicenseFormat, [self.license stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [mutableFilter appendString:@"&"];
    }
    NSString *lastCharacter = [mutableFilter substringWithRange:NSMakeRange(mutableFilter.length - 1, 1)];
    NSString *filter;
    if ([lastCharacter isEqualToString:@"&"]) {
        filter = [mutableFilter substringWithRange:NSMakeRange(0, mutableFilter.length - 1)];
    } else {
        filter = [NSString stringWithString:mutableFilter];
    }
    
    [CORE setFilter:filter];
    
    [CORE refreshControls];
}

#pragma mark - Search handler

- (void)RSCC_handleSearch:(NSSearchField *)searchField
{
    [self.controls removeAllObjects];
    
    [self.tableView reloadData];
    
    [self.progressIndicator startAnimation:self];
    
    NSString *key = searchField.stringValue;
    if ([key isEqualToString:@""]) {
        [CORE refreshControls];
    } else {
        [CORE searchControlsWithKey:key];
    }
}

#pragma mark - CORE notification handlers

- (void)RSCC_handleControlsDidLoad:(NSNotification *)aNotification
{
    [self.progressIndicator stopAnimation:self];
    
    [self.controls addObjectsFromArray:aNotification.object];
    
    [self.tableView reloadData];
}

- (void)RSCC_handleDetailDidLoad:(NSNotification *)aNotification
{
    [self.progressIndicator stopAnimation:self];
    
    RSCCControl *c = aNotification.object;
    if ([(NSButton *)[aNotification userInfo][@"sender"] tag] >= RSCCControlCellViewCloneButtonTagBase) {
        NSLog(@"Source : %@", c.source);
    } else {
        NSLog(@"Pod : %@", c.pod);
    }
}

#pragma mark - Popover buttons click event handlers

- (void)RSCC_handleSortButtonClicked:(NSButton *)sender
{
    self.sort = sender.title;
}

- (void)RSCC_handlePlatformButtonClicked:(NSButton *)sender
{
    if (![self.platform isEqualToString:sender.title]) {
        self.sort = RSCCADSortDefault;
        self.filterCocoaPods = RSCCADFilterCocoaPodsDefault;
        self.license = RSCCADLicenseDefault;
        
        self.sortButton.title = self.sort;
        self.filterCocoaPodsButton.title = self.filterCocoaPods;
        self.licenseButton.title = self.license;
    }
    self.platform = sender.title;
}

- (void)RSCC_handleFilterCocoaPodsButtonClicked:(NSButton *)sender
{
    self.filterCocoaPods = sender.title;
}

- (void)RSCC_handleLicenseButtonClicked:(NSButton *)sender
{
    self.license = sender.title;
}

#pragma mark - CellView and button click event handlers

- (void)RSCC_handleButtonClick:(NSButton *)sender
{
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
        RSCCControl *c = self.controls[row];
        [CORE.imageManager GET:c.image parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.imageView.image = responseObject;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        [self.imagePanel orderFront:self];
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

- (void)RSCC_handleCellDoubleClick:(id)sender
{
    RSCCControl *c = self.controls[self.tableView.clickedRow];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", RSCCAPIRoot, c.link]]];
}

#pragma mark - Getters

- (NSMutableArray *)controls
{
    if (!_controls) {
        _controls = [@[] mutableCopy];
    }
    return _controls;
}

#pragma mark - Getters for assigning default value

static NSString *const RSCCADSortDefault            = @"Date";
static NSString *const RSCCADPlatformDefault        = @"All";
static NSString *const RSCCADFilterCocoaPodsDefault = @"No";
static NSString *const RSCCADLicenseDefault         = @"All";

- (NSString *)sort
{
    if (!_sort) {
        _sort = RSCCADSortDefault;
    }
    return _sort;
}

- (NSString *)platform
{
    if (!_platform) {
        _platform = RSCCADPlatformDefault;
    }
    return _platform;
}

- (NSString *)filterCocoaPods
{
    if (!_filterCocoaPods) {
        _filterCocoaPods = RSCCADFilterCocoaPodsDefault;
    }
    return _filterCocoaPods;
}

- (NSString *)license
{
    if (!_license) {
        _license = RSCCADLicenseDefault;
    }
    return _license;
}

#pragma mark - NSApplication

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    [self.window makeKeyAndOrderFront:self];
    
    return NO;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RSCC_handleControlsDidLoad:) name:RSCCCoreControlsDidLoadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RSCC_handleDetailDidLoad:) name:RSCCCoreDetailDidLoadNotification object:nil];
    
    [self.tableView setDoubleAction:@selector(RSCC_handleCellDoubleClick:)];
    
    [self.progressIndicator setDisplayedWhenStopped:NO];
    [self.progressIndicator startAnimation:self];
    
    [self.searchField setTarget:self];
    [self.searchField setAction:@selector(RSCC_handleSearch:)];
    
    [self.filterButton setTarget:self];
    [self.filterButton setAction:@selector(RSCC_handleButtonClick:)];
    
    [self.sortButton setTarget:self];
    [self.sortButton setAction:@selector(RSCC_handleSortButtonClicked:)];
    
    [self.platformButton setTarget:self];
    [self.platformButton setAction:@selector(RSCC_handlePlatformButtonClicked:)];
    
    [self.filterCocoaPodsButton setTarget:self];
    [self.filterCocoaPodsButton setAction:@selector(RSCC_handleFilterCocoaPodsButtonClicked:)];
    
    [self.licenseButton setTarget:self];
    [self.licenseButton setAction:@selector(RSCC_handleLicenseButtonClicked:)];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.controls count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
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
        [cellView.cocoaPodsButton setHidden:!c.isOnCocoaPods];
        cellView.stars = @[cellView.star0,
                           cellView.star1,
                           cellView.star2,
                           cellView.star3,
                           cellView.star4];
        [CORE.imageManager GET:c.image parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [cellView.imageButton setImage:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [cellView.imageButton setImage:[NSImage imageNamed:@"placeholder"]];
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
