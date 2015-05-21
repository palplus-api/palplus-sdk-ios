//
// Created by ingram on 5/20/15.
//

#import "NSData+PAL.h"

@implementation NSData(PAL)

- (id) pal_ObjectFromJSONData {
  NSError* error;
  id result = [NSJSONSerialization JSONObjectWithData:self options:0 error:&error];
  if (error) {
    return nil;
  }
  return result;
}

@end