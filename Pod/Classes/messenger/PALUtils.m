#import "PALUtils.h"
#import "PALMessengerPref.h"
#import "NSURL+PAL.h"
#import "NSDictionary+PAL.h"
#import "PALAccessToken.h"
#import "PALMessengerHelper.h"
#import "UIImage+PAL.h"
#import "PALConstants.h"
#import "PALSdk.h"
#import "PALMessenger.h"
#import "PALMessengerDelegate.h"

@implementation PALUtils

+ (NSURL*) connectUrl {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@://connect?appKey=%@&appUniqueDeviceId=%@", PAL_SDK_SCHEME,
                                                         [PALSdk messenger].appKey,
                                                         [PALUtils appUniqueDeviceId]]];
}

+ (NSURL*) disconnectUrl:(NSString*) uid {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@://disconnect?appKey=%@&appUniqueDeviceId=%@&uid=%@", PAL_SDK_SCHEME,
                                                         [PALSdk messenger].appKey,
                                                         [PALUtils appUniqueDeviceId],
                                                         uid]];
}

+ (NSString*) appUniqueDeviceId {
  NSString* appUniqueDeviceId = [PALMessengerPref load:@"appUniqueDeviceId"];
  if (!appUniqueDeviceId) {
    appUniqueDeviceId = [[NSUUID UUID] UUIDString];
    [PALMessengerPref store:@"appUniqueDeviceId" value:appUniqueDeviceId];
  }
  return appUniqueDeviceId;
}

+ (BOOL) handleOpenUrl:(NSURL*) url sourceApplication:(NSString*) sourceApplication {
  if (![sourceApplication isEqualToString:@"com.liquable.nemo"]
      && ![sourceApplication isEqualToString:@"com.liquable.nemostage"]) {
    return NO;
  }

  if ([[url absoluteString]
      hasPrefix:[NSString stringWithFormat:@"%@-%@://connect", PAL_SDK_SCHEME, [PALSdk messenger].appKey]]) {
    NSDictionary* resultParams = [url pal_decodeParameters];
    PALAccessToken* accessToken = [[PALAccessToken alloc]
        initWithUid:[resultParams pal_stringOf:@"uid"]
       openApiAppId:[resultParams pal_stringOf:@"openApiAppId"]
        accessToken:[resultParams pal_stringOf:@"accessToken"]
         expireTime:[resultParams pal_longLongOf:@"expireTime"]];
    if ([accessToken isValid]) {
      if (![PALMessengerHelper getSession]) {
        [PALMessengerHelper init:nil];
      }
      [[PALMessengerHelper getSession] finishConnect:accessToken];
    }
    if ([[PALSdk messenger].delegate respondsToSelector:@selector(pal_messengerDidConnect:)]) {
      [[PALSdk messenger].delegate pal_messengerDidConnect:[PALSdk messenger]];
    }
    return YES;
  } else if ([[url absoluteString]
      hasPrefix:[NSString stringWithFormat:@"%@-%@://disconnect", PAL_SDK_SCHEME, [PALSdk messenger].appKey]]) {
    if ([PALMessengerHelper getSession]) {
      [[PALMessengerHelper getSession] finishDisconnect];
    }
    if ([[PALSdk messenger].delegate respondsToSelector:@selector(pal_messengerDidDisconnect:)]) {
      [[PALSdk messenger].delegate pal_messengerDidDisconnect:[PALSdk messenger]];
    }
    return YES;
  } else {
    if ([[PALSdk messenger].delegate respondsToSelector:@selector(pal_messenger:didOpenWithExecuteParams:)]) {
      [[PALSdk messenger].delegate pal_messenger:[PALSdk messenger] didOpenWithExecuteParams:[url query]];
    }
    return YES;
  }
  return NO;
}

+ (UIButton*) connectButton {
  UIButton* connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
  NSString* path = [[NSBundle mainBundle] pathForResource:@"palplus-sdk-ios" ofType:@"bundle"];
  NSBundle* bundle = [NSBundle bundleWithPath:path];
  [connectButton setTitle:[bundle localizedStringForKey:@"connect_with_palplus" value:@"Connect with Pal+" table:nil]
                 forState:UIControlStateNormal];
  [connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [connectButton setImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"palplus_connect_icon"
                                                                            ofType:@"png"]]
      forState:UIControlStateNormal];
  [connectButton setImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"palplus_connect_icon"
                                                                            ofType:@"png"]]
      forState:UIControlStateHighlighted];
  UIImage* normalImg = [UIImage pal_stretchableImageWithColor:[UIColor colorWithRed:0.0
                                                                              green:0.765625
                                                                               blue:0.61328
                                                                              alpha:1]];
  [connectButton setBackgroundImage:normalImg forState:UIControlStateNormal];
  UIImage* highlightedImg = [UIImage pal_stretchableImageWithColor:[UIColor colorWithRed:1
                                                                                   green:0.949
                                                                                    blue:0.4
                                                                                   alpha:1]];
  [connectButton setBackgroundImage:highlightedImg forState:UIControlStateHighlighted];
  connectButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
  connectButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
  [connectButton sizeToFit];
  connectButton.bounds = CGRectMake(connectButton.bounds.origin.x,
      connectButton.bounds.origin.y,
      connectButton.bounds.size.width + 24,
      connectButton.bounds.size.height + 12);
  connectButton.layer.masksToBounds = YES;
  connectButton.layer.cornerRadius = 5;
  return connectButton;
}

@end
