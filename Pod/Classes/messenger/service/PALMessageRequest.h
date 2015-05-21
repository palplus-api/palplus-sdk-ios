#import <Foundation/Foundation.h>

@class PALMessage;

@interface PALMessageRequest : NSObject

@property (nonatomic, readonly, copy) NSString* receiverUid;
@property (nonatomic, readonly, strong) PALMessage* palMessage;

- (NSData*) toJson;

+ (instancetype) requestWithReceiverUid:(NSString*) receiverUid withMessage:(PALMessage*) palMessage;

@end
