//
// Created by ingram on 5/14/15.
//

#import <Foundation/Foundation.h>

@interface PALPref : NSObject

- (BOOL) firstStarted;

- (void) setFirstStarted;

- (NSString*) fallbackDistinctId;

- (void) setStopQueue;

- (BOOL) isStopQueue;

+ (PALPref*) sharedInstance;

@end