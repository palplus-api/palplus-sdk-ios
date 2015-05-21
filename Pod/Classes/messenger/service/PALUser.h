#import <Foundation/Foundation.h>

@interface PALUser : NSObject
@property (nonatomic, readonly, copy) NSString* uid;
@property (nonatomic, readonly, copy) NSString* nickname;
@property (nonatomic, readonly, copy) NSString* iconUrl;

- (instancetype) initWithUid:(NSString*) uid nickname:(NSString*) nickname iconUrl:(NSString*) iconUrl;

+ (instancetype) decode:(NSDictionary*) raw;

@end
