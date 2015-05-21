//
// Created by ingram on 5/21/15.
//

#import <Foundation/Foundation.h>

@class PALMessenger;

@protocol PALMessengerDelegate<NSObject>
@optional

- (void) pal_messengerDidConnect:(PALMessenger*) messenger;

- (void) pal_messengerDidDisconnect:(PALMessenger*) messenger;

- (void) pal_messenger:(PALMessenger*) messenger didOpenWithExecuteParams:(NSString*) params;

@end