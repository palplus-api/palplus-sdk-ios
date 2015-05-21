//
// Created by ingram on 5/20/15.
//

#import <Foundation/Foundation.h>

typedef void (^PALHttpClientCallback)(NSData* responseBody, NSError* error);

@interface PALHttpClient : NSObject
+ (PALHttpClient*) sharedInstance;

- (void) post:(NSString*) url
  withHeaders:(NSDictionary*) headers
     withBody:(NSData*) body
 withCallback:(PALHttpClientCallback) callback;

- (void) get:(NSString*) url withHeaders:(NSDictionary*) headers withCallback:(PALHttpClientCallback) callback;

@end