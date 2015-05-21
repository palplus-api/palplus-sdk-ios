#import "PALMessageBuilder.h"
#import "PALMessage.h"
#import "PALMessageActionParams.h"

static int const IMAGE_WIDTH = 192;
static int const IMAGE_HEIGHT = 192;

@interface PALMessageBuilder()
@property (nonatomic, copy) NSString* text;
@property (nonatomic, copy) NSString* imageUrl;
@property (nonatomic, assign) int imageWidth;
@property (nonatomic, assign) int imageHeight;
@property (nonatomic, copy) NSString* linkText;
@property (nonatomic, copy) NSString* buttonText;
@property (nonatomic, strong) PALMessageActionParams* linkAction;
@property (nonatomic, strong) PALMessageActionParams* buttonAction;
@property (nonatomic, copy) NSString* notification;
@end

@implementation PALMessageBuilder

- (instancetype) initWithText:(NSString*) text
                     imageUrl:(NSString*) imageUrl
                   imageWidth:(int) imageWidth
                  imageHeight:(int) imageHeight
                     linkText:(NSString*) linkText
                   buttonText:(NSString*) buttonText
                   linkAction:(PALMessageActionParams*) linkAction
                 buttonAction:(PALMessageActionParams*) buttonAction
                 notification:(NSString*) notification
{
    self = [super init];
    if (self)
    {
        _text = text;
        _imageUrl = imageUrl;
        _imageWidth = imageWidth;
        _imageHeight = imageHeight;
        _linkText = linkText;
        _buttonText = buttonText;
        _linkAction = linkAction;
        _buttonAction = buttonAction;
        _notification = notification;
    }

    return self;
}

+ (instancetype) builder
{
    return [[self alloc] initWithText:nil
                             imageUrl:nil
                           imageWidth:0
                          imageHeight:0
                             linkText:nil
                           buttonText:nil
                           linkAction:nil
                         buttonAction:nil
                         notification:nil
    ];
}

- (instancetype) appButton:(NSString*) buttonText
{
    self.buttonText = buttonText;
    return self;
}

- (instancetype) appButton:(NSString*) buttonText action:(PALMessageActionParams*) buttonAction
{
    self.buttonAction = buttonAction;
    return [self appButton:buttonText];
}

- (instancetype) appLink:(NSString*) linkText
{
    self.linkText = linkText;
    return self;
}

- (instancetype) appLink:(NSString*) linkText action:(PALMessageActionParams*) linkAction
{
    self.linkAction = linkAction;
    return [self appLink:linkText];
}

- (instancetype) image:(NSString*) imageUrl
{
    self.imageUrl = imageUrl;
    self.imageWidth = IMAGE_WIDTH;
    self.imageHeight = IMAGE_HEIGHT;
    return self;
}

- (instancetype) text:(NSString*) text
{
    self.text = text;
    return self;
}

- (instancetype) notification:(NSString*) notification
{
    self.notification = notification;
    return self;
}


- (PALMessage*) build
{
    return [PALMessage messageWithText:self.text
                              imageUrl:self.imageUrl
                            imageWidth:self.imageWidth
                           imageHeight:self.imageHeight
                              linkText:self.linkText
               linkAndroidExecuteParam:self.linkAction ? self.linkAction.androidExecuteParam : nil
                linkAndroidMarketParam:self.linkAction ? self.linkAction.androidMarketParam : nil
                   linkIosExecuteParam:self.linkAction ? self.linkAction.iosExecuteParam : nil
                            buttonText:self.buttonText
             buttonAndroidExecuteParam:self.buttonAction ? self.buttonAction.androidExecuteParam : nil
              buttonAndroidMarketParam:self.buttonAction ? self.buttonAction.androidMarketParam : nil
                 buttonIosExecuteParam:self.buttonAction ? self.buttonAction.iosExecuteParam : nil
                          notification:self.notification];

}


@end
