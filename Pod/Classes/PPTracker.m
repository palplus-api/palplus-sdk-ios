//
// Created by ingram on 5/14/15.
//

#import "PPTracker.h"
#import "PPPref.h"
#import "V1ApiTrackingRequest.h"
#import "PPConstants.h"
#include <sys/sysctl.h>

static NSString* const ENDPOINT = @"https://trackingapi.palplus.me";

@implementation PPTracker
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
  if (![[PPPref sharedInstance] firstStarted]) {
    V1ApiTrackingRequest* request = [[V1ApiTrackingRequest alloc]
        initWithProperties:[self createProperties]
                     event:@"sdk_first_start"
               distinct_id:[PPPref sharedInstance].fallbackDistinctId];
    if ([self tryPost:[request toJsonData]]) {
      [[PPPref sharedInstance] setFirstStarted];
    }
  }

  V1ApiTrackingRequest* request = [[V1ApiTrackingRequest alloc]
      initWithProperties:[self createProperties]
                   event:@"sdk_app_start"
             distinct_id:[PPPref sharedInstance].fallbackDistinctId];
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
  NSData* responseBody = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
  if (error) {
    NSLog(@"http post error %@", error);
    return NO;
  }
  if ([response statusCode] == 499) {
    NSLog(@"server reject with status 499, stop future executions");
    [[PPPref sharedInstance] setStopQueue];
    return NO;
  }
  return YES;
}

@end