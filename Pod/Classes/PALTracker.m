//
// Created by ingram on 5/14/15.
//

#import "PALTracker.h"
#import "PALPref.h"
#import "PALV1ApiTrackingRequest.h"
#import "PALConstants.h"
#include <sys/sysctl.h>

static NSString* const ENDPOINT = @"https://trackingapi.palplus.me";

@implementation PALTracker
- (instancetype) init {
  self = [super init];
  if (self) {
  }

  return self;
}

- (NSString*) deviceModel {
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char answer[size];
  sysctlbyname("hw.machine", answer, &size, NULL, 0);
  NSString* results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
  return results;
}

- (NSMutableDictionary*) collectAutomaticProperties {
  NSMutableDictionary* p = [NSMutableDictionary dictionary];
  UIDevice* device = [UIDevice currentDevice];
  NSString* deviceModel = [self deviceModel];
  [p setValue:[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"] forKey:@"$app_version"];
  [p setValue:[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] forKey:@"$app_release"];
  [p setValue:@"Apple" forKey:@"$manufacturer"];
  [p setValue:[device systemName] forKey:@"$os"];
  [p setValue:[device systemVersion] forKey:@"$os_version"];
  [p setValue:deviceModel forKey:@"$model"];
  [p setValue:deviceModel forKey:@"mp_device_model"]; // legacy
  CGSize size = [UIScreen mainScreen].bounds.size;
  [p setValue:@((int) size.height) forKey:@"$screen_height"];
  [p setValue:@((int) size.width) forKey:@"$screen_width"];
  //
  //  require CoreTelephony framework
  //
  //  CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
  //  CTCarrier *carrier = [networkInfo subscriberCellularProvider];
  //  [networkInfo release];
  //  if (carrier.carrierName.length) {
  //    [p setValue:carrier.carrierName forKey:@"$carrier"];
  //  }
  return p;
}

- (NSDictionary*) createProperties {
  NSMutableDictionary* props = [NSMutableDictionary dictionary];
  [props addEntriesFromDictionary:[self collectAutomaticProperties]];
  props[@"app_id"] = [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
  props[@"sdk_version"] = PP_SDK_VERSION;
  return props;
}

- (void) start {
  if (![[PALPref sharedInstance] firstStarted]) {
    PALV1ApiTrackingRequest* request = [[PALV1ApiTrackingRequest alloc]
        initWithProperties:[self createProperties]
                     event:@"sdk_first_start"
               distinct_id:[PALPref sharedInstance].fallbackDistinctId];
    if ([self tryPost:[request toJsonData]]) {
      [[PALPref sharedInstance] setFirstStarted];
    }
  }

  PALV1ApiTrackingRequest* request = [[PALV1ApiTrackingRequest alloc]
      initWithProperties:[self createProperties]
                   event:@"sdk_app_start"
             distinct_id:[PALPref sharedInstance].fallbackDistinctId];
  [self tryPost:[request toJsonData]];
}

- (BOOL) tryPost:(NSData*) data {
  NSString* fullUrl = [NSString stringWithFormat:@"%@/v1/api/tracking/", ENDPOINT];
  NSURL* url = [NSURL URLWithString:fullUrl];
  NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
  [req setHTTPBody:data];
  [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [req setValue:[@(data.length) description] forHTTPHeaderField:@"Content-Length"];
  [req setHTTPMethod:@"POST"];
  NSHTTPURLResponse* response;
  NSError* error;
  [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
  if (error) {
    //NSLog(@"PALTracker post error %@", error);
    return NO;
  }
  if ([response statusCode] == 499) {
    NSLog(@"PALTracker server reject with status 499, stop future executions");
    [[PALPref sharedInstance] setStopQueue];
    return NO;
  }
  return YES;
}

@end