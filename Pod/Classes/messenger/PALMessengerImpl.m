#import "PALMessengerImpl.h"
#import "PALUser.h"
#import "PALUserAccessToken.h"
#import "PALFriendsResult.h"
#import "PALFriend.h"
#import "PALMessage.h"
#import "PALMessageRequest.h"
#import "PALMessengerHelper.h"
#import "PALTransactionRequest.h"
#import "PALMessageEmptyError.h"

#import "PALHttpClient.h"
#import "NSData+PAL.h"
#import "PALMessengerAccessDeniedError.h"
#import "PALMessengerDelegate.h"

static NSString* const AccessTokenHeaderKey = @"X-CUBIE-ACCESS-TOKEN";

@implementation PALMessengerImpl

+ (NSString*) endPoint {
#if TARGET_IPHONE_SIMULATOR
  return @"http://localhost:5580";
#endif
  return @"https://api.palplus.me";
}

- (instancetype) initWithAppKey:(NSString*) appKey {
  self = [super init];
  if (self) {
    _appKey = [appKey copy];
  }

  return self;
}

- (NSDictionary*) accessTokenHeaders {
  NSString* accessToken = [[PALMessengerHelper sharedInstance] getAccessToken];
  if (accessToken) {
    return @{AccessTokenHeaderKey : accessToken};
  }
  return @{};
}

- (BOOL) isConnected {
  return [[PALMessengerHelper sharedInstance] isOpen];
}

- (void) connect:(void (^)(BOOL success)) callback {
  [[PALMessengerHelper sharedInstance] open:^(PALMessengerHelper* session) {
    callback([session isOpen]);
  }];
}

- (void) disconnect:(void (^)(BOOL success)) callback {
  [[PALMessengerHelper sharedInstance] close:^(PALMessengerHelper* session) {
    callback(![session isOpen]);
  }];
}

- (void) extendAccessToken:(void (^)(PALUserAccessToken* accessToken, NSError* error)) done {
  NSLog(@"PALMessenger extendAccessToken");
  NSString* url = [NSString stringWithFormat:@"%@%@", [PALMessengerImpl endPoint], @"/v1/api/user/extend-access-token"];

  [[PALHttpClient sharedInstance]
      post:url withHeaders:[self accessTokenHeaders] withBody:nil withCallback:^(NSData* responseBody, NSError* error) {
    if (error) {
      [self handleClientError:error callback:done];
      return;
    }
    id decoded = [responseBody pal_ObjectFromJSONData];
    done([PALUserAccessToken decode:decoded], error);
  }];
}

- (void) handleClientError:(NSError*) error callback:(void (^)(id obj, NSError* error)) callback {
  if ([error isKindOfClass:[PALMessengerAccessDeniedError class]]) {
    if ([self.delegate respondsToSelector:@selector(pal_messengerConnectionInvalidated:)]) {
      [self.delegate pal_messengerConnectionInvalidated:self];
    }
  }
  callback(nil, error);
}

- (void) requestMe:(void (^)(PALUser* palUser, NSError* error)) done {
  NSString* url = [NSString stringWithFormat:@"%@%@", [PALMessengerImpl endPoint], @"/v1/api/user/me"];
  NSLog(@"PALMessenger requestMe:%@", url);
  [[PALHttpClient sharedInstance]
      get:url withHeaders:[self accessTokenHeaders] withCallback:^(NSData* responseBody, NSError* error) {
    if (error) {
      [self handleClientError:error callback:done];
      return;
    }
    id decoded = [responseBody pal_ObjectFromJSONData];
    done([PALUser decode:decoded], error);
  }];
}

- (void) requestFriends:(PALFriendsResult*) currentFriendsResult
               pageSize:(int) pageSize
                   done:(void (^)(PALFriendsResult* updatedFriendList, NSError* error)) done {
  NSLog(@"PALMessenger requestFriends:%@", currentFriendsResult);
  NSString* paramsString = nil;
  if (currentFriendsResult && [currentFriendsResult.allFriends count] > 0) {
    PALFriend* friend = [currentFriendsResult.allFriends lastObject];
    paramsString = [NSString stringWithFormat:@"size=%d&start-friend-uid=%@", pageSize, friend.uid];
  } else {
    paramsString = [NSString stringWithFormat:@"size=%d", pageSize];
  }

  NSString* url = [NSString stringWithFormat:@"%@%@?%@", [PALMessengerImpl endPoint], @"/v1/api/friend/list", paramsString];
  __weak PALFriendsResult* preventCircularRef = currentFriendsResult;
  [[PALHttpClient sharedInstance]
      get:url withHeaders:[self accessTokenHeaders] withCallback:^(NSData* responseBody, NSError* error) {
    if (error) {
      [self handleClientError:error callback:done];
      return;
    }
    PALFriendsResult* collect = preventCircularRef;
    if (!collect) {
      collect = [[PALFriendsResult alloc] init];
    }
    [collect update:[responseBody pal_ObjectFromJSONData]];
    done(collect, error);
  }];
}

- (void) sendMessage:(PALMessage*) palMessage to:(NSString*) receiverUid done:(void (^)(NSError* error)) done {
  if ([palMessage isEmpty]) {
    done([[PALMessageEmptyError alloc] initError]);
    return;
  }

  PALMessageRequest* messageRequest = [PALMessageRequest requestWithReceiverUid:receiverUid withMessage:palMessage];

  NSLog(@"PALMessenger sendMessage:%@", messageRequest);
  NSString* url = [NSString stringWithFormat:@"%@%@", [PALMessengerImpl endPoint], @"/v1/api/chat/app-message"];

  [[PALHttpClient sharedInstance]
        post:url
 withHeaders:[self accessTokenHeaders]
    withBody:[messageRequest toJson]
withCallback:^(NSData* responseBody, NSError* error) {
  if (error) {
    [self handleClientError:error callback:^(id obj, NSError* inError) {
      done(inError);
    }];
  } else {
    done(nil);
  }
}];

}

- (void) createTransaction:(NSString*) purchaseId
                  itemName:(NSString*) itemName
                  currency:(NSString*) currency
                     price:(NSDecimalNumber*) price
              purchaseDate:(NSDate*) purchaseDate
                     extra:(NSDictionary*) extra
                      done:(void (^)(NSError* error)) done {
  PALTransactionRequest* txRequest = [PALTransactionRequest create:purchaseId
                                                          itemName:itemName
                                                          currency:currency
                                                             price:price
                                                      purchaseDate:purchaseDate
                                                             extra:extra];

  NSLog(@"PALMessenger createTransaction:%@", txRequest);
  NSString* url = [NSString stringWithFormat:@"%@%@", [PALMessengerImpl endPoint], @"/v1/api/transaction/create"];
  [[PALHttpClient sharedInstance]
        post:url
 withHeaders:[self accessTokenHeaders]
    withBody:[txRequest toJson]
withCallback:^(NSData* responseBody, NSError* error) {
  if (error) {
    [self handleClientError:error callback:^(id obj, NSError* inError) {
      done(inError);
    }];
  } else {
    done(nil);
  }
}];
}
@end
