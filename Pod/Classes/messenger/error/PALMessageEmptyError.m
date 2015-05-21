#import "PALMessageEmptyError.h"

static NSString* const PALMessageEmptyErrorDomain = @"PALMessageEmptyErrorDomain";

@implementation PALMessageEmptyError
- (instancetype) initError {
  self = [super initWithDomain:PALMessageEmptyErrorDomain code:0 userInfo:nil];
  if (self) {

  }

  return self;
}

@end