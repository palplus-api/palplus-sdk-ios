#import "MessengerViewController.h"

#import "SendMessageViewController.h"
#import "PALUtils.h"
#import "PALSdk.h"
#import "PALMessenger.h"

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

  if ([[PALSdk messenger] isConnected]) {
    [self gotoSendMessageView];
  }
}

- (void) openPalPlus {
  __weak MessengerViewController* preventCirculerRef = self;
  [[PALSdk messenger] connect:^(BOOL success) {
    if (success) {
      [preventCirculerRef gotoSendMessageView];
    }
  }];
}

- (void) gotoSendMessageView {
  SendMessageViewController* sendMessageViewController = [[SendMessageViewController alloc] initSendMessage];
  [self.navigationController pushViewController:sendMessageViewController animated:YES];
}

@end
