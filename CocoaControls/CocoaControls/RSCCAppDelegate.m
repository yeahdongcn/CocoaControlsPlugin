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

- (void)RSCC_handleDoubleClick:(id)sender
{
    NSLog(@"%ld", self.tableView.clickedRow);
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
    
    [self.tableView setDoubleAction:@selector(RSCC_handleDoubleClick:)];
    
    [self.progressIndicator setDisplayedWhenStopped:NO];
    [self.progressIndicator startAnimation:self];
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
