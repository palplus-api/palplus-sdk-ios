//
// Created by ingram on 5/14/15.
//

#import "PALPref.h"
#import "PALConstants.h"

@implementation PALPref

+ (PALPref*) sharedInstance {
  static PALPref* _instance = nil;

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
  [self.userDefaults setBool:YES forKey:[NSString stringWithFormat:@"PP_stopQueue_%@", PAL_SDK_VERSION]];
}

- (BOOL) isStopQueue {
  return [self.userDefaults boolForKey:[NSString stringWithFormat:@"PP_stopQueue_%@", PAL_SDK_VERSION]];
}
@end