//
//  GrowlBridge.m
//  SiteMonitor
//
//  Created by Marinho Brandao on 24/01/11.
//  Copyright 2011 Raminel Web. All rights reserved.
//

#import "GrowlBridge.h"
#import <Growl/GrowlApplicationBridge.h>

@implementation GrowlBridge

// Init method
- (id) init { 
    if ( self = [super init] ) {
        // Tell growl we are going to use this class to hand growl notifications
        [GrowlApplicationBridge setGrowlDelegate:self];
    }
    return self;
}

// Begin methods from GrowlApplicationBridgeDelegate
- (NSDictionary *) registrationDictionaryForGrowl { // Only implement this method if you do not plan on just placing a plist with the same data in your app bundle (see growl documentation)
    NSArray *array = [NSArray arrayWithObjects:@"error", nil]; // each string represents a notification name that will be valid for us to use in alert methods
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:1], // growl 0.7 through growl 1.1 use ticket version 1
                          @"SiteMonitor", // Required key in dictionary
                          array, // defines which notification names our application can use, we defined example and error above
                          @"AllNotifications", // Required key in dictionary
                          array, // using the same array sets all notification names on by default
                          @"DefaultNotifications", // Required key in dictionary
                          nil];
    return dict;
}

- (void) nofifyErrorsAfterExecution: (NSArray *)errors {
    for (int e=0; e<[errors count]; e++) {
        id item = [errors objectAtIndex:e];
        id siteTitle = [[item valueForKey:@"site"] title];
        NSString* title = [NSString stringWithFormat:@"SiteMonitor - '%@'",siteTitle];
        NSString* msg = [item valueForKey:@"error"];
        [GrowlApplicationBridge notifyWithTitle:title
                                    description:msg
                               notificationName:@"error"
                                       iconData:nil
                                       priority:5
                                       isSticky:NO
                                   clickContext:nil];
    }
}

@end
