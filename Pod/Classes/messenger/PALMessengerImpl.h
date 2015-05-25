#import <Foundation/Foundation.h>
#import "PALMessenger.h"

@class PALUser;
@class PALUserAccessToken;
@class PALFriend;
@class PALFriendsResult;
@class PALMessage;
@class PALMessengerHelper;
@class PALTransactionRequest;
@protocol PALMessengerDelegate;

@interface PALMessengerImpl : NSObject<PALMessenger>

@property (nonatomic, readonly, copy) NSString* appKey;
@property (nonatomic, readwrite, assign) id<PALMessengerDelegate> delegate;

- (void) extendAccessToken:(void (^)(PALUserAccessToken* accessToken, NSError* error)) done;

- (instancetype) initWithAppKey:(NSString*) appKey;

@end
