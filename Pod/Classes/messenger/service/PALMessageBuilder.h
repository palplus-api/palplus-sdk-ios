#import <Foundation/Foundation.h>

@class PALMessage;
@class PALMessageActionParams;

@interface PALMessageBuilder : NSObject

+ (instancetype) builder;

- (instancetype) appButton:(NSString*) buttonText;

- (instancetype) appButton:(NSString*) buttonText action:(PALMessageActionParams*) buttonAction;

- (instancetype) appLink:(NSString*) linkText;

- (instancetype) appLink:(NSString*) linkText action:(PALMessageActionParams*) linkAction;

- (instancetype) image:(NSString*) imageUrl;

- (instancetype) text:(NSString*) text;

- (instancetype) notification:(NSString*) notification;

- (PALMessage*) build;

@end
