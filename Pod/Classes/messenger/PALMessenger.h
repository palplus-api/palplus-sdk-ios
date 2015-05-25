//
// Created by ingram on 5/22/15.
//

#import <Foundation/Foundation.h>

@class PALMessage;
@class PALFriendsResult;
@class PALUser;
@protocol PALMessengerDelegate;

@protocol PALMessenger<NSObject>

@property (nonatomic, readwrite, assign) id<PALMessengerDelegate> delegate;

- (BOOL) isConnected;

- (void) connect:(void (^)(BOOL success)) callback;

- (void) disconnect:(void (^)(BOOL success)) callback;

- (void) requestMe:(void (^)(PALUser* palUser, NSError* error)) done;

- (void) requestFriends:(PALFriendsResult*) currentFriendsResult
               pageSize:(int) pageSize
                   done:(void (^)(PALFriendsResult* updatedFriendsResult, NSError* error)) done;

- (void) sendMessage:(PALMessage*) palMessage to:(NSString*) receiverUid done:(void (^)(NSError* error)) done;

- (UIButton*) connectButton;

@end