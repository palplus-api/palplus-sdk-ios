//
// Created by ingram on 5/21/15.
//

#import <Foundation/Foundation.h>

@protocol PALMessenger;

@protocol PALMessengerDelegate<NSObject>
@optional

- (void) pal_messengerDidConnect:(id<PALMessenger>) messenger;

- (void) pal_messengerDidDisconnect:(id<PALMessenger>) messenger;

- (void) pal_messengerConnectionInvalidated:(id<PALMessenger>) messenger;

- (void) pal_messenger:(id<PALMessenger>) messenger didOpenWithExecuteParams:(NSString*) params;

@end