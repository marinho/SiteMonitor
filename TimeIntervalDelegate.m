//
//  TimeIntervalDelegate.m
//  SiteMonitor
//
//  Created by Marinho Brandao on 26/01/11.
//  Copyright 2011 Raminel Web. All rights reserved.
//

#import "TimeIntervalDelegate.h"


@implementation TimeIntervalDelegate

- (void)controlTextDidEndEditing:(NSNotification *)notification {
    NSTextField *input = [notification object];
    
    NSLog(@"%@",input);
}

@end
