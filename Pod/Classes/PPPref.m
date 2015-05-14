//
// Created by ingram on 5/14/15.
//

#import "PPPref.h"
#import "PPConstants.h"

@implementation PPPref

+ (PPPref*) sharedInstance {
  static PPPref* _instance = nil;

  @synchronized (self) {
    if (_instance == nil) {
      _instance = [[self alloc] init];
    }
  }

  return _instance;
}

- (NSUserDefaults*) userDefaults {
  return [NSUserDefaults standardUserDefaults];
}

- (BOOL) firstStarted {
  return [self.userDefaults boolForKey:@"PP_firstStarted"];
}

- (void) setFirstStarted {
  [self.userDefaults setBool:YES forKey:@"PP_firstStarted"];
}

- (NSString*) fallbackDistinctId {
  NSString* exist = [self.userDefaults stringForKey:@"PP_fallbackDistinctId"];
  if (!exist) {
    NSString* idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    exist = [NSString stringWithFormat:@"FALLBACK_%@", idfv];
    [self.userDefaults setObject:exist forKey:@"PP_fallbackDistinctId"];
  }
  return exist;
}

- (void) setStopQueue {
  [self.userDefaults setBool:YES forKey:[NSString stringWithFormat:@"PP_stopQueue_%@", PP_SDK_VERSION]];
}

- (BOOL) isStopQueue {
  return [self.userDefaults boolForKey:[NSString stringWithFormat:@"PP_stopQueue_%@", PP_SDK_VERSION]];
}
@end