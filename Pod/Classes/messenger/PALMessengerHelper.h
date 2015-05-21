#import <Foundation/Foundation.h>

@class PALAccessToken;
@class PALMessengerPref;

@interface PALMessengerHelper : NSObject

typedef void (^SessionCallback)(PALMessengerHelper* session);

+ (PALMessengerHelper*) getSession;

+ (void) init:(SessionCallback) callback;

- (void) open:(SessionCallback) callback;

- (void) close:(SessionCallback) callback;

- (void) close;

- (void) finishConnect:(PALAccessToken*) accessToken;

- (void) finishDisconnect;

- (BOOL) isOpen;

- (long long) getExpireTime;

- (NSString*) getAccessToken;

- (void) testMakeAccessTokenNeedToRefresh;

- (void) testInvalidAccessToken;

@end
