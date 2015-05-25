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

/**
* @return user has connected to Pal+
*/
- (BOOL) isConnected;

/**
* redirect user to Pal+ and ask for authorization to one's profile and friends
* @param callback whether the connection is successful
*/
- (void) connect:(void (^)(BOOL success)) callback;

/**
* disconnect the current user from Pal+
* @param callback whether the disconnection is successful
*/
- (void) disconnect:(void (^)(BOOL success)) callback;

/**
* request my profile information including nickname and icon URL
*
* the user must first be connected to Pal+ to call this method
*/
- (void) requestMe:(void (^)(PALUser* palUser, NSError* error)) done;

/**
* request a list of friends with their information including uid, nickname and icon URL
*
* the user must first be connected to Pal+ to call this method
*/
- (void) requestFriends:(PALFriendsResult*) currentFriendsResult
               pageSize:(int) pageSize
                   done:(void (^)(PALFriendsResult* updatedFriendsResult, NSError* error)) done;

/**
* send a custom message to a Pal+ friend
*
* @param palMessage a message built by using PALMessageBuilder, may include text/image/link/button
* @param receiverUid a uid of a friend obtained by calling requestFriends:
*
* the user must first be connected to Pal+ to call this method
*/
- (void) sendMessage:(PALMessage*) palMessage to:(NSString*) receiverUid done:(void (^)(NSError* error)) done;

/**
* @return a Pal+ styled connect button, you have to call connect: manually when user tap on it
*/
- (UIButton*) connectButton;

@end