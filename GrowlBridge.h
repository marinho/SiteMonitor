//
//  GrowlBridge.h
//  SiteMonitor
//
//  Created by Marinho Brandao on 24/01/11.
//  Copyright 2011 Raminel Web. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/GrowlApplicationBridge.h>

@interface GrowlBridge : NSObject {}

- (NSDictionary *) registrationDictionaryForGrowl;
- (void) nofifyErrorsAfterExecution: (NSArray *)errors;

@end
