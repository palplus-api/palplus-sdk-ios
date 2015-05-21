#import <Foundation/Foundation.h>


@interface PALFriend : NSObject

@property (nonatomic, readonly, copy) NSString* uid;
@property (nonatomic, readonly, copy) NSString* nickname;
@property (nonatomic, readonly, copy) NSString* iconUrl;
@property (nonatomic, readonly, assign) BOOL appInstalled;

- (instancetype) initWithUid:(NSString*) uid
                    nickname:(NSString*) nickname
                     iconUrl:(NSString*) iconUrl
                appInstalled:(BOOL) appInstalled;

+ (instancetype) decode:(NSDictionary*) raw;

@end
