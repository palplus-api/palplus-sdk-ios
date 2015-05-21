#import "PALMessengerError.h"

static NSString* const PALServiceErrorDomain = @"PALServiceErrorDomain";

@implementation PALMessengerError

- (instancetype) initWithReason:(NSString*) reason code:(NSInteger) code {
  self = [super initWithDomain:PALServiceErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey : reason}];
  if (self) {
  }

  return self;
}

+ (instancetype) decode:(NSDictionary*) raw {
  return [[self alloc] initWithReason:raw[@"reason"] code:[raw[@"code"] integerValue]];
}

@end

