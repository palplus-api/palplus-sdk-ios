#import "PALMessengerHelper.h"

@implementation UIViewController(PAL)

- (void) pal_didSessionChangedWithOpenSelector:(SEL) onOpen withCloseSelector:(SEL) onClose {
  if ([PALMessengerHelper getSession] && [[PALMessengerHelper getSession] isOpen]) {
    NSLog(@"UIViewController+PAL isOpen");
    if (onOpen) {
      [self performSelector:onOpen withObject:nil afterDelay:0];
    }
  } else {
    NSLog(@"UIViewController+PAL init");
    __weak UIViewController* preventCircularRef = self;
    [PALMessengerHelper init:^(PALMessengerHelper* session) {
      NSLog(@"UIViewController+PAL init:%d", [session isOpen]);
      if ([session isOpen]) {
        if (onOpen) {
          [preventCircularRef performSelector:onOpen withObject:nil afterDelay:0];
        }
      } else {
        if (onClose) {
          [preventCircularRef performSelector:onClose withObject:nil afterDelay:0];
        }
      }
    }];
  }
}

- (void) pal_connectWithOpenSelector:(SEL) onOpen {
  NSLog(@"UIViewController+PAL onOpen");
  __weak UIViewController* preventCircularRef = self;
  [[PALMessengerHelper getSession] open:^(PALMessengerHelper* session) {
    if ([session isOpen]) {
      NSLog(@"UIViewController+PAL pal_connectWithOpenSelector:%d", [session isOpen]);
      if (onOpen) {
        [preventCircularRef performSelector:onOpen withObject:nil afterDelay:0];
      }
    }
  }];
}

- (void) pal_disconnectWithCloseSelector:(SEL) onClose {
  NSLog(@"UIViewController+PAL onClose");
  __weak UIViewController* preventCircularRef = self;
  [[PALMessengerHelper getSession] close:^(PALMessengerHelper* session) {
    NSLog(@"UIViewController+PAL pal_disconnectWithCloseSelector:%d", [session isOpen]);
    if (![session isOpen]) {
      if (onClose) {
        [preventCircularRef performSelector:onClose withObject:nil afterDelay:0];
      }
    }
  }];
}

@end