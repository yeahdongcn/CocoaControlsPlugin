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

@interface RSCCAppDelegate () <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *controls;

@property (nonatomic, weak) IBOutlet NSTableView *tableView;

@property (nonatomic, weak) IBOutlet NSProgressIndicator *progressIndicator;

@end

@implementation RSCCAppDelegate

- (NSMutableArray *)controls
{
    if (!_controls) {
        _controls = [@[] mutableCopy];
    }
    return _controls;
}

- (void)RSCC_handleDoubleClick:(id)sender
{
    NSLog(@"%ld", self.tableView.clickedRow);
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.controls count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{    
    NSString *identifier = tableColumn.identifier;
    if ([identifier isEqualToString:@"ControlCell"]) {
        RSCCControlCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        RSCCControl *c = self.controls[row];
        cellView.titleField.stringValue = c.title;
        cellView.licenseField.stringValue = c.license;
        cellView.dateField.stringValue = c.date;
        [cellView.cocoaPodsButton setHidden:!c.isOnCocoaPods];
        return cellView;
    }
    return nil;
}

- (void)controlsDidLoad:(NSNotification *)aNotification
{
    [self.progressIndicator stopAnimation:self];
    
    [self.controls addObjectsFromArray:aNotification.object];
    
    [self.tableView reloadData];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controlsDidLoad:) name:RSCCCoreControlsDidLoadNotification object:nil];
    
    [self.tableView setDoubleAction:@selector(RSCC_handleDoubleClick:)];
    
    [self.progressIndicator setDisplayedWhenStopped:NO];
    [self.progressIndicator startAnimation:self];
}

@end
