//
//  AppController.h
//  SiteMonitor
//
//  Created by Marinho Brandao on 23/01/11.
//  Copyright 2011 Raminel Web. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SitesDataSource.h"
#import "Site.h"
#import "GrowlBridge.h"

@interface AppController : NSObject {
    GrowlBridge *growlBridge;
    NSString *editSiteState;
    NSTimer* timer;
    
    IBOutlet id sitesTableView;
    IBOutlet id inputInterval;
    IBOutlet id inputIntervalStepper;
    IBOutlet id inputEnabledMonitoring;
    IBOutlet id panelSheet;
    IBOutlet id panelInputTitle;
    IBOutlet id panelInputURL;
    IBOutlet id panelInputStatusCode;
    IBOutlet id panelInputEnabled;
    IBOutlet id windowPreferences;
}

- (IBAction) doExecute: (id)pId;
- (IBAction) doAddSite: (id)pId;
- (IBAction) doEditSite: (id)pId;
- (IBAction) doDeleteSite: (id)pId;
- (IBAction) doConfirmEditSite: (id)pId;
- (IBAction) doCancelEditSite: (id)pId;
- (IBAction) onTimeIntervalChange: (id)pId;
- (IBAction) onEnabledMonitoringChange: (id)pId;
- (IBAction) doShowPreferences: (id)pId;

- (void) startTimer;
- (void) executeSitesMonitoring;
- (void) complete: (NSTimer *)senderTimer;
- (void) updateTableView;
- (void) updatePreferenceControls;
- (id) siteByIdentifier: (NSString *)identifier;

@property (retain) GrowlBridge *growlBridge;
@property (retain) NSString *editSiteState;
@property (retain) id sitesTableView;
@property (retain) id inputInterval;
@property (retain) id inputIntervalStepper;
@property (retain) id inputEnabledMonitoring;
@property (retain) id panelSheet;
@property (retain) id panelInputTitle;
@property (retain) id panelInputURL;
@property (retain) id panelInputStatusCode;
@property (retain) id panelInputEnabled;
@end
