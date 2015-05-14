//
// Created by ingram on 5/14/15.
//

#import <Foundation/Foundation.h>

@interface PPPref : NSObject

- (BOOL) firstStarted;

- (void) setFirstStarted;

- (NSString*) fallbackDistinctId;

- (void) setStopQueue;

- (BOOL) isStopQueue;

+ (PPPref*) sharedInstance;

@end