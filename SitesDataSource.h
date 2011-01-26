//
//  SitesDataSource.h
//  SiteMonitor
//
//  Created by Marinho Brandao on 22/01/11.
//  Copyright 2011 Raminel Web. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Site.h"

@interface SitesDataSource : NSObject {
    id delegate;
    NSMutableArray *sites;
    BOOL enabledMonitoring;
    NSInteger interval;
    IBOutlet id inputInterval;
    IBOutlet id inputIntervalStepper;
    IBOutlet id inputEnabledMonitoring;
}

- (NSMutableArray *) sites;

- (id) delegate;
- (void) setDelegate: (id)newDelegate;
- (NSInteger) interval;
- (void) setInterval: (NSInteger)input;
- (BOOL) enabledMonitoring;
- (void) setEnabledMonitoring: (BOOL)input;

- (NSInteger) numberOfRowsInTableView: (NSTableView *)tableView;
- (id) tableView:(NSTableView *)tableView objectValueForTableColumn: (NSTableColumn *)tableColumn row:(NSInteger)index;

- (NSMutableArray *)executeAllSites;
- (void) saveToFile: (NSString *)fileName;
- (void) loadFromFile: (NSString *)fileName;
- (NSString *) defaultFileName;

@property (assign,getter=delegate,setter=setDelegate:) id delegate;
@property (retain,getter=sites) NSMutableArray *sites;
@property (getter=enabledMonitoring,setter=setEnabledMonitoring:) BOOL enabledMonitoring;
@property (getter=interval,setter=setInterval:) NSInteger interval;
@end
