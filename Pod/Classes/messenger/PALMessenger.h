#import <Foundation/Foundation.h>

extern const int PALDefaultFriendListPageSize;

@class PALUser;
@class PALUserAccessToken;
@class PALFriend;
@class PALFriendsResult;
@class PALMessage;
@class PALMessengerHelper;
@class PALTransactionRequest;
@protocol PALMessengerDelegate;

@interface PALMessenger : NSObject

@property (nonatomic, readonly, copy) NSString* appKey;
@property (nonatomic, readwrite, assign) id<PALMessengerDelegate> delegate;

- (void) extendAccessToken:(void (^)(PALUserAccessToken* accessToken, NSError* error)) done;

- (instancetype) initWithAppKey:(NSString*) appKey;

- (void) requestMe:(void (^)(PALUser* palUser, NSError* error)) done;

- (void) requestFriends:(PALFriendsResult*) currentFriendsResult
               pageSize:(int) pageSize
                   done:(void (^)(PALFriendsResult* updatedFriendsResult, NSError* error)) done;

- (void) sendMessage:(PALMessage*) palMessage to:(NSString*) receiverUid done:(void (^)(NSError* error)) done;

@end