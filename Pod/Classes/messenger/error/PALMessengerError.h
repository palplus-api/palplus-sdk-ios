#import <Foundation/Foundation.h>


@interface PALMessengerError : NSError
- (instancetype) initWithReason:(NSString*) reason code:(NSInteger) code;

+ (instancetype) decode:(NSDictionary*) raw;
@end