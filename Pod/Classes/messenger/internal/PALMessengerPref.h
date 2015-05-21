#import <Foundation/Foundation.h>

@class PALAccessToken;


@interface PALMessengerPref : NSObject

+ (void) storeAccessToken:(PALAccessToken*) accessToken;

+ (PALAccessToken*) loadAccessToken;

+ (void) clearAccessToken;

+ (id) load:(NSString*) key;

+ (void) store:(NSString*) key value:(id) value;

@end
