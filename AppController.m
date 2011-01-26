//
//  AppController.m
//  SiteMonitor
//
//  Created by Marinho Brandao on 23/01/11.
//  Copyright 2011 Raminel Web. All rights reserved.
//

#import "AppController.h"
#import "GrowlBridge.h"
#import "Site.h"

@implementation AppController

- (id) init {
    if (self = [super init]) {
        growlBridge = [[GrowlBridge alloc] init];
        
        [self startTimer];
    }
    
    return self;
}

- (void) dealloc {
    [growlBridge release];
    
    [super dealloc];
}

- (void) startTimer {
    NSThread* timerThread = [[NSThread alloc] initWithTarget:self
                                                    selector:@selector(startTimerThread)
                                                      object:nil];
    [timerThread start];
}

- (void) startTimerThread {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    id ds = [[SitesDataSource alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:[ds interval]
                                                      target:self
                                                    selector:@selector(timerEvent:)
                                                    userInfo:nil
                                                     repeats:YES];
    [timer retain];
    
    [runLoop run];
    [pool release];
}

- (void) timerEvent: (NSTimer *)timer {
    id ds = [sitesTableView dataSource];

    if ([ds enabledMonitoring]) {
        [self executeSitesMonitoring];
    } else {
        NSLog(@"Monitoring disabled.");
    }
}

- (IBAction) doExecute: (id)pId {
    [self executeSitesMonitoring];
}

- (IBAction) doAddSite: (id)pId {
    [panelInputTitle selectText:nil];
    editSiteState = @"adding";
    
    [NSApp beginSheet: panelSheet
       modalForWindow: windowPreferences
        modalDelegate: self
       didEndSelector: @selector(didEndSheet:returnCode:contextInfo:)
          contextInfo: nil];
}

- (IBAction) doEditSite: (id)pId {
    NSInteger index = [sitesTableView selectedRow];
    
    if (index >= 0) {
        id site = [[[sitesTableView dataSource] sites] objectAtIndex:index];
        editSiteState = @"editing";
        
        [panelInputTitle selectText:nil];
        
        [panelInputTitle setStringValue:[site title]];
        [panelInputURL setStringValue:[site url]];
        [panelInputStatusCode setIntegerValue:[site validStatusCode]];
        [panelInputEnabled setState:[site enabled] ? NSOnState : NSOffState];
        
        [NSApp beginSheet: panelSheet
           modalForWindow: windowPreferences
            modalDelegate: self
           didEndSelector: @selector(didEndSheet:returnCode:contextInfo:)
              contextInfo: nil];
    }
}

- (IBAction) doDeleteSite: (id)pId {
    NSInteger index = [sitesTableView selectedRow];
    
    if (index >= 0) {
        id ds = [sitesTableView dataSource];
        id site = [[ds sites] objectAtIndex:index];
        
        [[ds sites] removeObject:[self siteByIdentifier:[site identifier]]];
        [ds saveToFile:[ds defaultFileName]];
        
        [self updateTableView];
    }
}

- (IBAction) doConfirmEditSite: (id)pId {
    id ds = [sitesTableView dataSource];
    
    if (editSiteState == @"editing") {
        NSInteger index = [sitesTableView selectedRow];
        
        id found_site = [[ds sites] objectAtIndex:index];
        id site = [self siteByIdentifier:[found_site identifier]];
        
        [site setTitle:[panelInputTitle stringValue]];
        [site setUrl:[panelInputURL stringValue]];
        [site setValidStatusCode:[panelInputStatusCode integerValue]];
        [site setEnabled:[panelInputEnabled state] == NSOnState];
    } else {
        id site = [[Site alloc] init];
        
        [site setTitle:[panelInputTitle stringValue]];
        [site setUrl:[panelInputURL stringValue]];
        [site setValidStatusCode:[panelInputStatusCode integerValue]];
        [site setEnabled:[panelInputEnabled state] == NSOnState];
        
        [[ds sites] addObject:site];
    }
    
    [self updateTableView];
    
    [panelInputTitle setStringValue:@""];
    [panelInputURL setStringValue:@""];
    [panelInputStatusCode setIntegerValue:200];
    [panelInputEnabled setState:NSOnState];
    [NSApp endSheet:panelSheet];
    
    [ds saveToFile:[ds defaultFileName]];
}

- (IBAction) doCancelEditSite: (id)pId {
    [panelInputTitle setStringValue:@""];
    [panelInputURL setStringValue:@""];
    [panelInputStatusCode setIntegerValue:200];
    [panelInputEnabled setState:NSOnState];
    [NSApp endSheet:panelSheet];
}

- (IBAction) onTimeIntervalChange: (id)pId {
    id ds = [sitesTableView dataSource];
    [ds setInterval:[pId integerValue]];
    [ds saveToFile:[ds defaultFileName]];
    [self updatePreferenceControls];
}

- (void) updatePreferenceControls {
    id ds = [sitesTableView dataSource];
    
    [inputInterval setIntegerValue:[ds interval]];
    [inputIntervalStepper setIntegerValue:[ds interval]];
    [inputEnabledMonitoring setState:[ds enabledMonitoring]?NSOnState:NSOffState];
}

- (IBAction) onEnabledMonitoringChange: (id)pId {
    id ds = [sitesTableView dataSource];
    [ds setEnabledMonitoring:[pId state]==NSOnState];
    [ds saveToFile:[ds defaultFileName]];
}

- (IBAction) doShowPreferences: (id)pId {
    [self updatePreferenceControls];
    [windowPreferences makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)executeSitesMonitoring {
    id errors = [[sitesTableView dataSource] executeAllSites];
    
    [growlBridge nofifyErrorsAfterExecution:errors];
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo{
    [panelSheet orderOut:self];
}

- (void) updateTableView {
    [sitesTableView reloadData];
}

- (id)siteByIdentifier: (NSString *)identifier {
    id ds = [sitesTableView dataSource];
    id site = nil;
    
    for (int index=0; index<[[ds sites] count]; index++ ) {
        id temp_site = [[ds sites] objectAtIndex:index];
        
        if ([temp_site identifier] == identifier) {
            site = temp_site;
            break;
        }
    }
    
    return site;
}

@synthesize growlBridge;
@synthesize editSiteState;
@synthesize sitesTableView;
@synthesize inputInterval;
@synthesize inputIntervalStepper;
@synthesize inputEnabledMonitoring;
@synthesize panelSheet;
@synthesize panelInputTitle;
@synthesize panelInputURL;
@synthesize panelInputStatusCode;
@synthesize panelInputEnabled;
@end
