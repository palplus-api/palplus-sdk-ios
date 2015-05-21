//
// Created by ingram on 5/14/15.
//

#import <Foundation/Foundation.h>

@interface PALV1ApiTrackingRequest : NSObject
@property (nonatomic, readonly, copy) NSDictionary* properties;
@property (nonatomic, readonly, copy) NSString* event;
@property (nonatomic, readonly, copy) NSString* distinct_id;

- (instancetype) initWithProperties:(NSDictionary*) properties
                              event:(NSString*) event
                        distinct_id:(NSString*) distinct_id;

- (NSData*) toJsonData;
@end