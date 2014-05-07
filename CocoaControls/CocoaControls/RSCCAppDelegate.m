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

@property (nonatomic, strong) NSMutableArray *controls;

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, weak) IBOutlet NSSearchField *searchField;

@property (nonatomic, weak) IBOutlet NSTableView *tableView;

@property (nonatomic, weak) IBOutlet NSProgressIndicator *progressIndicator;

@property (nonatomic, weak) IBOutlet NSPanel *imagePanel;

@property (nonatomic, weak) IBOutlet NSImageView *imageView;

@property (nonatomic, weak) IBOutlet NSButton *filterButton;

@property (nonatomic, weak) IBOutlet NSPopover *popover;

@end

@implementation RSCCAppDelegate

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

- (void)RSCC_handlePodDidLoad:(NSNotification *)aNotification
{
    [self.progressIndicator stopAnimation:self];
    
    RSCCControl *c = aNotification.object;
    NSLog(@"%@", c.pod);
}

- (void)RSCC_handleButtonClick:(NSButton *)sender
{
    if (sender.tag >= RSCCControlCellViewCocoaPodsButtonTagBase) {
        NSInteger row = sender.tag - RSCCControlCellViewCocoaPodsButtonTagBase;
        RSCCControl *c = self.controls[row];
        if (c.pod) {
            [self RSCC_handlePodDidLoad:[[NSNotification alloc] initWithName:RSCCCorePodDidLoadNotification object:c userInfo:nil]];
        } else {
            [CORE podForControl:c];
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
            [self.popover showRelativeToRect:[self.filterButton bounds]
                                      ofView:self.filterButton
                               preferredEdge:NSMaxYEdge];
        } else {
            [self.popover close];
        }
    }
}

- (void)RSCC_handleCellDoubleClick:(id)sender
{
    RSCCControl *c = self.controls[self.tableView.clickedRow];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", RSCCAPIRoot, c.link]]];
}

- (void)RSCC_handleControlsDidLoad:(NSNotification *)aNotification
{
    [self.progressIndicator stopAnimation:self];
    
    [self.controls addObjectsFromArray:aNotification.object];
    
    [self.tableView reloadData];
}

- (NSMutableArray *)controls
{
    if (!_controls) {
        _controls = [@[] mutableCopy];
    }
    return _controls;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RSCC_handleControlsDidLoad:) name:RSCCCoreControlsDidLoadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RSCC_handlePodDidLoad:) name:RSCCCorePodDidLoadNotification object:nil];
    
    [self.tableView setDoubleAction:@selector(RSCC_handleCellDoubleClick:)];
    
    [self.progressIndicator setDisplayedWhenStopped:NO];
    [self.progressIndicator startAnimation:self];

    [self.searchField setTarget:self];
    [self.searchField setAction:@selector(RSCC_handleSearch:)];
    
    [self.filterButton setTarget:self];
    [self.filterButton setAction:@selector(RSCC_handleButtonClick:)];
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
        if ([cellView.imageButton target] == nil) {
            [cellView.imageButton setTarget:self];
            [cellView.imageButton setAction:@selector(RSCC_handleButtonClick:)];
        }
        if ([cellView.cocoaPodsButton target] == nil) {
            [cellView.cocoaPodsButton setTarget:self];
            [cellView.cocoaPodsButton setAction:@selector(RSCC_handleButtonClick:)];
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
