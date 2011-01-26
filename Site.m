//
//  Site.m
//  SiteMonitor
//
//  Created by Marinho Brandao on 22/01/11.
//  Copyright 2011 Raminel Web. All rights reserved.
//

#import "Site.h"
#import "WrongStatusCode.h"
#import "HostNotReached.h"

@implementation Site

- (id) init {
    if (self = [super init]) {
        identifier = [self generateUUID];
        title = @"";
        url = @"";
        _validStatusCode = 200;
        _enabled = YES;
    }
    
    return self;
}

- (void) dealloc {
    [identifier release];
    [title release];
    [url release];
    
    [super dealloc];
}

- (NSString *) identifier {
    return identifier;
}

- (void) setIdentifier: (NSString *)input {
    [identifier autorelease];
    identifier = [input retain];
}

- (NSString *) title {
    return title;
}

- (void) setTitle: (NSString *)input {
    [title autorelease];
    title = [input retain];
}

- (NSString *) url {
    return url;
}

- (void) setUrl: (NSString *)input {
    [url autorelease];
    url = [input retain];
}

- (NSInteger) validStatusCode {
    return _validStatusCode;
}

- (void) setValidStatusCode: (NSInteger)input {
    _validStatusCode = input;
}

- (BOOL) enabled {
    return _enabled;
}

- (void) setEnabled: (BOOL)input {
    _enabled = input;
}

- (NSString *) generateUUID {
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    // transfer ownership of the string
    // to the autorelease pool
    [uuidString autorelease];
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

- (BOOL) execute {
    //NSDate *dateBefore = [NSDate date];
    NSError *error;
    NSMutableURLRequest *request;
    NSURLResponse *response;
    NSHTTPURLResponse *httpResponse;
    NSData *receivedData;
    id receivedString;
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    receivedData = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if (receivedData) {
        receivedString = (NSString *)[[NSString alloc] initWithData:receivedData
                                                           encoding:NSUTF8StringEncoding];
        httpResponse = (NSHTTPURLResponse *)response;
        //NSDate *dateAfter = [NSDate date];
        //NSTimeInterval interval = [dateAfter timeIntervalSinceDate:dateBefore];

        // Invalid status code
        if ([httpResponse statusCode] != _validStatusCode) {
            NSString *reason = [NSString stringWithFormat:@"Status code %d instead of %d",[httpResponse statusCode],_validStatusCode];
            @throw [WrongStatusCode exceptionWithName:@"WrongStatusCode"
                                               reason:reason
                                             userInfo:nil];
        }
    } else {
        @throw [HostNotReached exceptionWithName:@"HostNotReached"
                                          reason:@"Host not reached"
                                        userInfo:nil];
    }
    
    return YES;
}

@end
