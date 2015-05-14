//
// Created by ingram on 5/14/15.
//

#import "V1ApiTrackingRequest.h"

@implementation V1ApiTrackingRequest

- (instancetype) initWithProperties:(NSDictionary*) properties
                              event:(NSString*) event
                        distinct_id:(NSString*) distinct_id {
  self = [super init];
  if (self) {
    _properties = [properties copy];
    _event = [event copy];
    _distinct_id = [distinct_id copy];
  }

  return self;
}

- (NSData*) toJsonData {
  NSDictionary* dict = @{
      @"event" : self.event, @"properties" : self.properties, @"distinct_id" : self.distinct_id
  };
  NSError* error;
  NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
  if (error) {
    return nil;
  }
  return data;
}

@end