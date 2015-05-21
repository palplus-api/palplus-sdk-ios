#import <Foundation/Foundation.h>

@interface UIViewController(PAL)
- (void) pal_didSessionChangedWithOpenSelector:(SEL) onOpen withCloseSelector:(SEL) onClose;

- (void) pal_connectWithOpenSelector:(SEL) onOpen;

- (void) pal_disconnectWithCloseSelector:(SEL) onClose;
@end