//
// Created by ingram on 5/20/15.
//

#import "PALHttpClient.h"
#import "PALMessengerAccessDeniedError.h"

NSTimeInterval PALHttpClientRequestTimeoutInterval = 10;

@interface PALHttpClient()
@property (nonatomic, readonly, strong) dispatch_queue_t requestQueue;
@end

@implementation PALHttpClient

+ (PALHttpClient*) sharedInstance {
  static PALHttpClient* _instance = nil;

  @synchronized (self) {
    if (_instance == nil) {
      _instance = [[self alloc] init];
    }
  }
  return _instance;
}

- (instancetype) init {
  self = [super init];
  if (self) {
    _requestQueue = dispatch_queue_create("me.palplus.sdk.httpclient", DISPATCH_QUEUE_CONCURRENT);
  }

  return self;
}

- (void) post:(NSString*) fullUrl
  withHeaders:(NSDictionary*) headers
     withBody:(NSData*) body
 withCallback:(PALHttpClientCallback) callback {

  dispatch_async(self.requestQueue, ^{ // 1
    NSURL* url = [NSURL URLWithString:fullUrl];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if (body) {
      [req setHTTPBody:body];
      [req setValue:[@(body.length) description] forHTTPHeaderField:@"Content-Length"];
    } else {
      [req setValue:[@(0) description] forHTTPHeaderField:@"Content-Length"];
    }
    if (headers) {
      for (NSString* key in headers) {
        [req setValue:headers[key] forHTTPHeaderField:key];
      }
    }
    [req setHTTPMethod:@"POST"];
    [req setTimeoutInterval:PALHttpClientRequestTimeoutInterval];
    NSHTTPURLResponse* response;
    NSError* error;
    NSData* responseBody = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    // -1012 is status 401
    if (error.code == NSURLErrorUserCancelledAuthentication) {
      NSLog(@"PALHttpClient post access denied %@", error);
      error = [[PALMessengerAccessDeniedError alloc] initError];
      responseBody = nil;
    }
    if (error) {
      NSLog(@"PALHttpClient post error %@", error);
      responseBody = nil;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
      callback(responseBody, error);
    });

  });

}

- (void) get:(NSString*) fullUrl withHeaders:(NSDictionary*) headers withCallback:(PALHttpClientCallback) callback {

  dispatch_async(self.requestQueue, ^{ // 1
    NSURL* url = [NSURL URLWithString:fullUrl];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"GET"];
    [req setTimeoutInterval:PALHttpClientRequestTimeoutInterval];
    if (headers) {
      for (NSString* key in headers) {
        [req setValue:headers[key] forHTTPHeaderField:key];
      }
    }
    NSHTTPURLResponse* response;
    NSError* error;
    NSData* responseBody = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    if (error.code == NSURLErrorUserCancelledAuthentication) {
      NSLog(@"PALHttpClient get access denied %@", error);
      error = [[PALMessengerAccessDeniedError alloc] initError];
      responseBody = nil;
    }
    if (error) {
      NSLog(@"PALHttpClient get error %@", error);
      responseBody = nil;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
      callback(responseBody, error);
    });

  });

}

@end