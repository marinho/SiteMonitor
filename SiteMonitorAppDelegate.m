//
//  SiteMonitorAppDelegate.m
//  SiteMonitor
//
//  Created by Marinho Brandao on 21/01/11.
//  Copyright 2011 Raminel Web. All rights reserved.
//

#import "SiteMonitorAppDelegate.h"

@implementation SiteMonitorAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
	statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    [statusItem retain];
    
    [statusItem setTitle:@"SM"];
    [statusItem setHighlightMode:YES];
    [statusItem setMenu:menuStatus];
}

@synthesize statusItem;
@synthesize menuStatus;
@end
