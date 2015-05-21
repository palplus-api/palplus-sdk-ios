#import "PALMessageRequest.h"
#import "PALMessage.h"
#import "NSDictionary+PAL.h"

@implementation PALMessageRequest

- (instancetype) initWithReceiverUid:(NSString*) receiverUid withMessage:(PALMessage*) palMessage {
  self = [super init];
  if (self) {
    _receiverUid = receiverUid;
    _palMessage = palMessage;
  }

  return self;
}

+ (instancetype) requestWithReceiverUid:(NSString*) receiverUid withMessage:(PALMessage*) palMessage {
  return [[self alloc] initWithReceiverUid:receiverUid withMessage:palMessage];
}

+ (id) trimToNull:(NSString*) value {
  if (!value || value.length == 0) {
    return [NSNull null];
  }
  return value;
}

- (NSData*) toJson {
  NSDictionary* dictionary = @{
      @"receiver_uid" : self.receiverUid,
      @"text" : [PALMessageRequest trimToNull:self.palMessage.text],
      @"image_url" : [PALMessageRequest trimToNull:self.palMessage.imageUrl],
      @"image_width" : [NSString stringWithFormat:@"%d", self.palMessage.imageWidth],
      @"image_height" : [NSString stringWithFormat:@"%d", self.palMessage.imageHeight],
      @"link_text" : [PALMessageRequest trimToNull:self.palMessage.linkText],
      @"link_android_execute_param" : [PALMessageRequest trimToNull:self.palMessage.linkAndroidExecuteParam],
      @"link_android_market_param" : [PALMessageRequest trimToNull:self.palMessage.linkAndroidMarketParam],
      @"link_ios_execute_param" : [PALMessageRequest trimToNull:self.palMessage.linkIosExecuteParam],
      @"button_text" : [PALMessageRequest trimToNull:self.palMessage.buttonText],
      @"button_android_execute_param" : [PALMessageRequest trimToNull:self.palMessage.buttonAndroidExecuteParam],
      @"button_android_market_param" : [PALMessageRequest trimToNull:self.palMessage.buttonAndroidMarketParam],
      @"button_ios_execute_param" : [PALMessageRequest trimToNull:self.palMessage.buttonIosExecuteParam],
      @"notification" : [PALMessageRequest trimToNull:self.palMessage.notification]
  };
  return [dictionary pal_JSONData];
}

- (NSString*) description {
  NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
  [description appendFormat:@"receiverUid=%@", self.receiverUid];
  [description appendFormat:@", palMessage=%@", self.palMessage];
  [description appendString:@">"];
  return description;
}

@end
