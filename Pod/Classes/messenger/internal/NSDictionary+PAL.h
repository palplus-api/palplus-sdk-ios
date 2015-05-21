#import <Foundation/Foundation.h>

@interface NSDictionary(PAL)

- (NSString*) pal_stringOf:(id) key;

- (int) pal_intOf:(id) key;

- (NSInteger) pal_integerOf:(id) key;

- (long long) pal_longLongOf:(id) key;

- (double) pal_doubleOf:(id) key;

- (NSArray*) pal_arrayOf:(id) key;

- (NSDictionary*) pal_dictionaryOf:(id) key;

- (BOOL) pal_boolOf:(id) key;

/**
* return nil if value is [NSNull null]
*/
- (id) pal_objectOf:(id) key;

- (NSData*) pal_JSONData;

@end
