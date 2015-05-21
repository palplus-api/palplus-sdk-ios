#import "NSURL+PAL.h"

@implementation NSURL(PAL)

- (NSDictionary*) pal_decodeParameters {
  NSMutableDictionary* params = [NSMutableDictionary dictionary];

  if (self.query != nil && self.query.length > 0) {
    for (NSString* param in [self.query componentsSeparatedByString:@"&"]) {
      NSArray* keyValuePair = [param componentsSeparatedByString:@"="];
      if ([keyValuePair count] < 2) {
        continue;
      }
      params[[keyValuePair[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] = [keyValuePair[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
  }

  return params;
}

@end