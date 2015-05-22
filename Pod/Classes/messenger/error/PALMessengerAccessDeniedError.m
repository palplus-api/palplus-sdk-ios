#import "PALMessengerAccessDeniedError.h"

static NSString* const PALMessengerAccessDeniedErrorDomain = @"PALMessengerAccessDeniedErrorDomain";

@implementation PALMessengerAccessDeniedError

- (instancetype) initError {
  self = [super initWithDomain:PALMessengerAccessDeniedErrorDomain
                          code:401
                      userInfo:@{@"reason" : @"invalid access token"}];
  if (self) {
  }

  return self;
}

@end

