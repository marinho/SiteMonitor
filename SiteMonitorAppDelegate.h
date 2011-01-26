//
//  SiteMonitorAppDelegate.h
//  SiteMonitor
//
//  Created by Marinho Brandao on 21/01/11.
//  Copyright 2011 Raminel Web. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SiteMonitorAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSStatusItem *statusItem;
    IBOutlet id menuStatus;
}

@property (assign) IBOutlet NSWindow *window;

@property (retain) NSStatusItem *statusItem;
@property (retain) id menuStatus;
@end
