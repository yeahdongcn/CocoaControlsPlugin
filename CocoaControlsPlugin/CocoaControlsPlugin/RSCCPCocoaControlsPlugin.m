//
//  RSCCPCocoaControlsPlugin.m
//  RSCCPCocoaControlsPlugin
//
//  Created by R0CKSTAR on 5/8/14.
//    Copyright (c) 2014 P.D.Q. All rights reserved.
//

#import "RSCCPCocoaControlsPlugin.h"
#import "CCPProject.h"

#import <CoreFoundation/CFNotificationCenter.h>

static RSCCPCocoaControlsPlugin *sharedPlugin;

@interface RSCCPCocoaControlsPlugin()

@property (nonatomic) NSBundle *bundle;
@property (nonatomic, weak) NSWindow *keyWindow;

@end

@implementation RSCCPCocoaControlsPlugin

- (void) RSCCP_openCocoaControlsApp {
    NSString *applicationBundlePathString = [self.bundle pathForAuxiliaryExecutable:@"CocoaControls.app"];
    NSString *executablePathString = [NSString stringWithFormat:@"%@%@", applicationBundlePathString, @"/Contents/MacOS/CocoaControls"];
    [NSTask launchedTaskWithLaunchPath:executablePathString arguments:@[]];
}

- (void) RSCCP_createPodfile {
    CCPProject *project = [CCPProject projectForWindow:self.keyWindow];
    if (project) {
        NSString *podFilePath = project.podfilePath;
        if (![project hasPodfile]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] copyItemAtPath:[self.bundle pathForResource:@"DefaultPodfile" ofType:@""] toPath:podFilePath error:&error];
            if (error) {
                [[NSAlert alertWithError:error] runModal];
            }
        }
        
        NSFileHandle* fileHandle = [NSFileHandle fileHandleForWritingAtPath:podFilePath];
        @try {
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:[[NSString stringWithFormat:@"%@%@", @"\n", [[NSPasteboard generalPasteboard] stringForType:NSPasteboardTypeString]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        @catch (NSException *e) {
            NSLog(@"%@", e);
        }
        [fileHandle closeFile];
        
        [[[NSApplication sharedApplication] delegate] application:[NSApplication sharedApplication]
                                                         openFile:podFilePath];
    }
}

+ (void)pluginDidLoad:(NSBundle*)plugin {
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

static void NotificationReceivedCallback(CFNotificationCenterRef center,
                                         void *observer, CFStringRef name,
                                         const void *object, CFDictionaryRef
                                         userInfo) {
    [sharedPlugin RSCCP_createPodfile];
}

- initWithBundle:(NSBundle*)plugin {
    if (self = [super init]) {
        // reference to plugin's bundle, for resource acccess
        self.bundle = plugin;
        
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &NotificationReceivedCallback, CFSTR("com.pdq.rscccocoapods"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"View"];
        if (menuItem) {
            [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
            
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Cocoa Controls"
                                                                    action:@selector(RSCCP_openCocoaControlsApp)
                                                             keyEquivalent:@"c"];
            [actionMenuItem setKeyEquivalentModifierMask:NSControlKeyMask];
            [actionMenuItem setTarget:self];
            [[menuItem submenu] addItem:actionMenuItem];
        }
    }
    return self;
}

- (BOOL) validateMenuItem:(NSMenuItem*)menuItem {
    if ([CCPProject projectForKeyWindow]) {
        if (!self.keyWindow) {
            self.keyWindow = NSApplication.sharedApplication.keyWindow;
        }
    }
    return YES;
}

@end
