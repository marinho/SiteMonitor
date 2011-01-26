//
//  Site.h
//  SiteMonitor
//
//  Created by Marinho Brandao on 22/01/11.
//  Copyright 2011 Raminel Web. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Site : NSObject {
    NSString *identifier;
    NSString *title;
    NSString *url;
    NSInteger _validStatusCode;
    BOOL _enabled;
}

- (NSString *) identifier;
- (void) setIdentifier: (NSString *)input;

- (NSString *) title;
- (void) setTitle: (NSString *)input;

- (NSString *) url;
- (void) setUrl: (NSString *)input;

- (NSInteger) validStatusCode;
- (void) setValidStatusCode: (NSInteger)input;

- (BOOL) enabled;
- (void) setEnabled: (BOOL)input;

- (NSString *) generateUUID;

- (BOOL) execute;

@property (getter=validStatusCode,setter=setValidStatusCode:) NSInteger _validStatusCode;
@property (getter=enabled,setter=setEnabled:) BOOL _enabled;
@end
