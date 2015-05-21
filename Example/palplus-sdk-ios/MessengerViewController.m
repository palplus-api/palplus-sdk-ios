#import "MessengerViewController.h"
#import "SendMessageViewController.h"
#import "UIViewController+PAL.h"
#import "PALUtils.h"

@implementation MessengerViewController

- (instancetype) initMessenger {
  self = [super init];
  if (self) {
  }

  return self;
}

- (void) viewDidLoad {
  [super viewDidLoad];

  self.navigationController.navigationBar.topItem.title = @"Demo";

  UIButton* connectButton = [PALUtils connectButton];
  [connectButton addTarget:self action:@selector(openPalPlus) forControlEvents:UIControlEventTouchUpInside];
  connectButton.center = self.view.center;
  [self.view addSubview:connectButton];
}

- (void) viewDidAppear:(BOOL) animated {
  [super viewDidAppear:animated];
  [self pal_didSessionChangedWithOpenSelector:@selector(gotoSendMessageView) withCloseSelector:nil];
}

- (void) gotoSendMessageView {
  SendMessageViewController* sendMessageViewController = [[SendMessageViewController alloc] initSendMessage];
  [self.navigationController pushViewController:sendMessageViewController animated:YES];
}

- (void) openPalPlus {
  [self pal_connectWithOpenSelector:@selector(gotoSendMessageView)];
}

@end
