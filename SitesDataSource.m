//
//  SitesDataSource.m
//  SiteMonitor
//
//  Created by Marinho Brandao on 22/01/11.
//  Copyright 2011 Raminel Web. All rights reserved.
//

#import "SitesDataSource.h"
#import "BaseException.h"

@implementation SitesDataSource

- (id) init {
    if (self = [super init]) {
        sites = [[NSMutableArray alloc] init];
        
        [self setEnabledMonitoring:YES];
        [self setInterval:30]; //60 * 5;
        
        [self loadFromFile:[self defaultFileName]];
    }
    
    return self;
}

- (void) dealloc {
    [sites release];
    
    [super dealloc];
}

- (NSMutableArray *) sites {
    return sites;
}

- (id) delegate {
    return delegate;
}

- (void) setDelegate: (id)newDelegate {
    delegate = newDelegate;
}

- (NSInteger) interval {
    return interval;
}

- (void) setInterval: (NSInteger)input {
    interval = input;
}

- (BOOL) enabledMonitoring {
    return enabledMonitoring;
}

- (void) setEnabledMonitoring: (BOOL)input {
    enabledMonitoring = input;
}

- (NSMutableArray *)executeAllSites {
    NSMutableArray *errors = [[NSMutableArray alloc] init];
    
    for (int index=0; index<[sites count]; index++) {
        id site = [sites objectAtIndex:index];
        
        // Only enabled sites are monitored
        if (![site enabled]) { continue; }
        
        @try {
            [site execute];
        } @catch (BaseException *e) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:site forKey:@"site"];
            [dict setValue:[e reason] forKey:@"error"];
            [errors addObject:dict];
        }
    }
    
    return errors;
}

- (NSInteger) numberOfRowsInTableView: (NSTableView *)tableView {
    return [sites count];
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn: (NSTableColumn *)tableColumn row:(NSInteger)index {
    id site = [sites objectAtIndex:index];
    id label = @"";
    
    if ([[tableColumn identifier] isEqualToString:@"title"]) {
        label = [site title];
    } else if ([[tableColumn identifier] isEqualToString:@"url"]) {
        label = [site url];
    } else if ([[tableColumn identifier] isEqualToString:@"validStatusCode"]) {
        label = [NSString stringWithFormat:@"%d",[site validStatusCode]];
    } else if ([[tableColumn identifier] isEqualToString:@"enabled"]) {
        if ([site enabled]) {
            label = @"YES"; //NSOnState;
        } else {
            label = @"NO"; //NSOffState;
        }
    }
    
    NSString* extra = [site enabled] ? @"" : @"color='gray'" ;
    NSData* html = [[NSString stringWithFormat:@"<font face='helvetica' %@>%@</font>",extra,label] dataUsingEncoding:NSUTF8StringEncoding];    
    NSAttributedString* ret = [[NSAttributedString alloc] initWithHTML:html documentAttributes:nil];

    return ret;
}

- (void) saveToFile: (NSString *)fileName {
    id plist = [[NSMutableDictionary alloc] init];
    
    // Sites list
    id sitesList = [[NSMutableArray alloc] init];
    for (int index=0;index<[sites count]; index++) {
        id dict = [[NSMutableDictionary alloc] init];
        NSString *strStatusCode = [NSString stringWithFormat:@"%d",[[sites objectAtIndex:index] validStatusCode]];
        NSString *strEnabled = [[sites objectAtIndex:index] enabled]?@"YES":@"NO";
        [dict setValue:[[sites objectAtIndex:index] identifier] forKey:@"identifier"];
        [dict setValue:[[sites objectAtIndex:index] title] forKey:@"title"];
        [dict setValue:[[sites objectAtIndex:index] url] forKey:@"url"];
        [dict setValue:strStatusCode forKey:@"validStatusCode"];
        [dict setValue:strEnabled forKey:@"enabledSite"];
        [sitesList addObject:dict];
    }
    
    // General params
    [plist setValue:sitesList forKey:@"sites"];
    [plist setValue:[NSString stringWithFormat:@"%d",interval] forKey:@"interval"];
    [plist setValue:(enabledMonitoring?@"YES":@"NO") forKey:@"enabledMonitoring"];
    
    NSString *error;
    NSData *xmlData = [NSPropertyListSerialization dataFromPropertyList:plist
                                                                 format:NSPropertyListXMLFormat_v1_0
                                                       errorDescription:&error];
    
    if (xmlData) {
        [xmlData writeToFile:fileName atomically:YES];
    } else {
        NSLog(error);
        [error release];
    }
}

- (void) loadFromFile: (NSString *)fileName {
    NSData *xmlData = [NSData dataWithContentsOfFile:fileName];
    NSString *error;
    NSPropertyListFormat format;
    id plist;
    
    plist = [NSPropertyListSerialization propertyListFromData:xmlData
                                             mutabilityOption:NSPropertyListImmutable
                                                       format:&format
                                             errorDescription:&error];
    
    if (!plist) {
        NSLog(error);
        [error release];
    } else {
        [self setInterval:[[plist valueForKey:@"interval"] integerValue]];
        [self setEnabledMonitoring:[[plist valueForKey:@"enabledMonitoring"] isEqualToString:@"YES"]];
        
        id sitesList = [plist valueForKey:@"sites"];
        for (int index=0; index<[sitesList count]; index++) {
            Site *site = [[Site alloc] init];
            
            [site setIdentifier:[[sitesList objectAtIndex:index] valueForKey:@"identifier"]];
            [site setTitle:[[sitesList objectAtIndex:index] valueForKey:@"title"]];
            [site setUrl:[[sitesList objectAtIndex:index] valueForKey:@"url"]];
            [site setValidStatusCode:[[[sitesList objectAtIndex:index] valueForKey:@"validStatusCode"] integerValue]];
            [site setEnabled:[[[sitesList objectAtIndex:index] valueForKey:@"enabledSite"] boolValue]];
            
            [sites addObject:site];
        }
    }
}

- (NSString *) defaultFileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Preferences"
                                                     ofType:@"plist"];
    return path;
}

@synthesize sites;
@end
