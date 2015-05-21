#import "PALUser.h"

@implementation PALUser

- (instancetype) initWithUid:(NSString*) uid nickname:(NSString*) nickname iconUrl:(NSString*) iconUrl {
  self = [super init];
  if (self) {
    _uid = uid;
    _nickname = nickname;
    _iconUrl = iconUrl;
  }

  return self;
}

+ (instancetype) decode:(NSDictionary*) raw {
  return [[self alloc] initWithUid:raw[@"uid"] nickname:raw[@"nickname"] iconUrl:raw[@"icon_url"]];
}

- (NSString*) description {
  NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
  [description appendFormat:@"uid=%@", self.uid];
  [description appendFormat:@", nickname=%@", self.nickname];
  [description appendFormat:@", iconUrl=%@", self.iconUrl];
  [description appendString:@">"];
  return description;
}

@end
