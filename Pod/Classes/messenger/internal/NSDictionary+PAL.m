@implementation NSDictionary(PAL)

- (NSString*) pal_stringOf:(id) key {
  id value = [self objectForKey:key];
  return value == [NSNull null] ? nil : value;
}

- (int) pal_intOf:(id) key {
  id value = [self objectForKey:key];
  return value == [NSNull null] ? 0 : [(NSNumber*) value intValue];

}

- (NSInteger) pal_integerOf:(id) key {
  id value = [self objectForKey:key];
  return value == [NSNull null] ? 0 : [(NSNumber*) value integerValue];

}

- (long long) pal_longLongOf:(id) key {
  id value = [self objectForKey:key];
  return value == [NSNull null] ? 0 : [(NSNumber*) value longLongValue];
}

- (double) pal_doubleOf:(id) key {
  id value = [self objectForKey:key];
  return value == [NSNull null] ? 0 : [(NSNumber*) value doubleValue];

}

- (NSArray*) pal_arrayOf:(id) key {
  id value = [self objectForKey:key];
  return value == [NSNull null] ? nil : value;
}

- (NSDictionary*) pal_dictionaryOf:(id) key {
  id value = [self objectForKey:key];
  return value == [NSNull null] ? nil : value;
}

- (BOOL) pal_boolOf:(id) key {
  id value = [self objectForKey:key];
  return value == [NSNull null] ? NO : [(NSNumber*) value boolValue];
}

/**
* return nil if value is [NSNull null]
*/
- (id) pal_objectOf:(id) key {
  id value = [self objectForKey:key];
  return value == [NSNull null] ? nil : value;
}

- (NSData*) pal_JSONData {
  NSError* error;
  NSData* data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
  if (error) {
    return nil;
  }
  return data;
}

@end
