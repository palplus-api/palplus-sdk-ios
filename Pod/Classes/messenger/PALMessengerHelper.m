#import "PALSdk.h"
#import "PALMessengerHelper.h"
#import "PALAccessToken.h"
#import "PALMessengerPref.h"
#import "PALMessengerImpl.h"
#import "PALUserAccessToken.h"
#import "PALUtils.h"
#import "PALConstants.h"

static const long long MIN_REFRESH_INTERVAL = 30LL * 24 * 60 * 60 * 1000; // 30 days



@interface PALMessengerHelper()<UIAlertViewDelegate>
@property (nonatomic, strong) PALAccessToken* accessToken;
@property (nonatomic, strong) NSObject* lock;
@property (nonatomic, copy) SessionCallback callback;
@end

@implementation PALMessengerHelper

+ (PALMessengerHelper*) sharedInstance {
  static PALMessengerHelper* _instance = nil;
  @synchronized (self) {
    if (_instance == nil) {
      _instance = [[self alloc] initSession];
      if (!_instance) {
        NSLog(@"PALMessengerHelper init");
        _instance = [[PALMessengerHelper alloc] initSession];
      }
      [_instance reopen];
    }
  }

  return _instance;
}

- (instancetype) initSession {
  self = [super init];
  if (self) {
    _accessToken = nil;
    _lock = [NSObject new];
    _callback = nil;
  }

  return self;
}

- (void) reopen {
  if ([self isOpen]) {
    return;
  }

  NSLog(@"PALMessengerHelper reopen");
  PALAccessToken* loadedAccessToken;
  loadedAccessToken = [PALMessengerPref loadAccessToken];
  @synchronized (self.lock) {
    self.accessToken = loadedAccessToken;
  }

  [self refreshAccessTokenIfNecessary];
}

- (void) refreshAccessTokenIfNecessary {
  if (![self needToRefreshAccessToken]) {
    return;
  }

  NSLog(@"PALMessengerHelper refresh");
  PALMessengerImpl* messenger = [PALSdk messenger];
  [messenger extendAccessToken:^(PALUserAccessToken* userAccessToken, NSError* error) {
    if (error) {
      [self close];
      return;
    }
    [self updateAccessToken:[[PALAccessToken alloc]
        initWithUid:userAccessToken.uid
       openApiAppId:userAccessToken.appId
        accessToken:userAccessToken.accessToken
         expireTime:(long long) ([userAccessToken.expireDate timeIntervalSince1970] * 1000)]];
  }];
}

- (BOOL) needToRefreshAccessToken {
  long long int expireTime = [self.accessToken expireTime];
  long long int currentTime = (long long) ([[NSDate date] timeIntervalSince1970] * 1000);
  @synchronized (self.lock) {
    return [self isOpen] && expireTime - currentTime < MIN_REFRESH_INTERVAL;
  }
}

- (void) open:(SessionCallback) callback {
  if (![self checkUrlScheme]) {
    [self notifySessionCallback:callback];
    return;
  }

  if ([self isOpen]) {
    [self notifySessionCallback:callback];
    return;
  }

  NSURL* connectUrl = [PALUtils connectUrl];
  NSLog(@"PALMessengerHelper open:%@", connectUrl);
  if (![[UIApplication sharedApplication] canOpenURL:connectUrl]) {
    [self askUserToUpdateOrInstall];
    [self notifySessionCallback:callback];
    return;
  }

  self.callback = callback;
  [[UIApplication sharedApplication] openURL:connectUrl];
}

- (BOOL) checkUrlScheme {
  PALMessengerImpl* messenger = [PALSdk messenger];
  if (!messenger) {
    return NO;
  }
  NSString* openUrl = [NSString stringWithFormat:@"%@-%@", PAL_SDK_SCHEME, messenger.appKey];
  NSArray* urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
  if (urlTypes) {
    for (NSDictionary* urlType in urlTypes) {
      NSArray* urlSchemes = urlType[@"CFBundleURLSchemes"];
      if (urlSchemes) {
        for (NSString* urlScheme in urlSchemes) {
          if ([urlScheme isEqualToString:openUrl]) {
            return YES;
          }
        }
      }
    }
  }
  [[[UIAlertView alloc]
      initWithTitle:[NSString stringWithFormat:@"url scheme %@ not defined in Info.plist", openUrl]
            message:nil
           delegate:self
  cancelButtonTitle:@"OK"
  otherButtonTitles:nil]
      show];
  return NO;
}

- (void) close:(SessionCallback) callback {
  self.callback = callback;
  if (![self isOpen]) {
    [self notifySessionCallback:callback];
    return;
  }

  NSURL* disconnectUrl = [PALUtils disconnectUrl:[self getUid]];
  NSLog(@"PALMessengerHelper close:%@", disconnectUrl);
  if (![[UIApplication sharedApplication] canOpenURL:disconnectUrl]) {
    [self close];
    return;
  }

  [[UIApplication sharedApplication] openURL:disconnectUrl];
}

- (void) close {
  NSLog(@"PALMessengerHelper close");
  @synchronized (self.lock) {
    [PALMessengerPref clearAccessToken];
    self.accessToken = nil;
  }
}

- (void) finishConnect:(PALAccessToken*) accessToken {
  NSLog(@"PALMessengerHelper finishConnect:%@", accessToken);
  [self updateAccessToken:accessToken];
  [self notifySessionCallback:self.callback];
  self.callback = nil;
}

- (void) finishDisconnect {
  NSLog(@"PALMessengerHelper finishDisconnect");
  [self close];
  [self notifySessionCallback:self.callback];
  self.callback = nil;
}

- (BOOL) isOpen {
  @synchronized (self.lock) {
    return self.accessToken && [self.accessToken isValid];
  }
}

- (NSString*) getUid {
  @synchronized (self.lock) {
    if (!self.accessToken) {
      return nil;
    }
    return [self.accessToken uid];
  }
}

- (NSString*) getOpenApiAppId {
  @synchronized (self.lock) {
    if (!self.accessToken) {
      return nil;
    }
    return [self.accessToken openApiAppId];
  }

}

- (long long) getExpireTime {
  @synchronized (self.lock) {
    if (!self.accessToken) {
      return 0;
    }
    return [self.accessToken expireTime];
  }

}

- (NSString*) getAccessToken {
  @synchronized (self.lock) {
    if (!self.accessToken) {
      return nil;
    }
    return [self.accessToken accessToken];
  }

}

- (void) updateAccessToken:(PALAccessToken*) input {
  NSLog(@"PALMessengerHelper updateAccessToken:%@", input);
  @synchronized (self.lock) {
    self.accessToken = input;
    [PALMessengerPref storeAccessToken:self.accessToken];
  }
}

- (void) notifySessionCallback:(SessionCallback) callback {
  if (!callback) {
    return;
  }

  callback(self);
}

- (void) askUserToUpdateOrInstall {
  NSLog(@"askUserToUpdateOrInstall");
  UIAlertView* alertView = [[UIAlertView alloc]
      initWithTitle:@"Require latest Pal+ app"
            message:@"your verison does not support Pal+ sdk integration"
           delegate:self
  cancelButtonTitle:@"Later"
  otherButtonTitles:@"Go to App Store", nil];
  [alertView show];
}

- (void) alertView:(UIAlertView*) alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
  if (buttonIndex == [alertView cancelButtonIndex]) {
    return;
  }
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://palplus.me/download"]];
}

- (void) testMakeAccessTokenNeedToRefresh {
  if (![self isOpen]) {
    return;
  }

  NSLog(@"PALMessengerHelper testMakeAccessTokenNeedToRefresh");
  [self updateAccessToken:[[PALAccessToken alloc]
      initWithUid:[self getUid]
     openApiAppId:[self getOpenApiAppId]
      accessToken:[self getAccessToken]
       expireTime:(long long int) (([[NSDate date] timeIntervalSince1970] + 3600) * 1000)]];
}

- (void) testInvalidAccessToken {
  if (![self isOpen]) {
    return;
  }

  NSLog(@"PALMessengerHelper testInvalidAccessToken");
  [self updateAccessToken:[[PALAccessToken alloc]
      initWithUid:[self getUid] openApiAppId:[self getOpenApiAppId] accessToken:@"BAD" expireTime:0]];
}
@end
