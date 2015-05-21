#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PALUtils : NSObject

+ (NSURL*) connectUrl;

+ (NSURL*) disconnectUrl:(NSString*) uid;

+ (NSString*) appUniqueDeviceId;

+ (BOOL) handleOpenUrl:(NSURL*) url sourceApplication:(NSString*) sourceApplication;

+ (UIButton*) connectButton;

@end
