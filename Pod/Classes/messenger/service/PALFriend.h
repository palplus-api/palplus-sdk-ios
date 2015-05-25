#import <Foundation/Foundation.h>

@interface PALFriend : NSObject

/**
* unique id for a friend which is used for sending message using PALMessenger.sendMessage:
*/
@property (nonatomic, readonly, copy) NSString* uid;

@property (nonatomic, readonly, copy) NSString* nickname;
@property (nonatomic, readonly, copy) NSString* iconUrl;

/**
* whether this friend has installed the connected app
*/
@property (nonatomic, readonly, assign) BOOL appInstalled;

- (instancetype) initWithUid:(NSString*) uid
                    nickname:(NSString*) nickname
                     iconUrl:(NSString*) iconUrl
                appInstalled:(BOOL) appInstalled;

+ (instancetype) decode:(NSDictionary*) raw;

@end
