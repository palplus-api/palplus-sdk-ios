#import "PALSdk.h"
#import "SendMessageViewController.h"
#import "PALMessenger.h"
#import "PALUser.h"
#import "UIImageView+AFNetworking.h"
#import "Views.h"
#import "PALMessageBuilder.h"
#import "PALMessageActionParams.h"
#import "SelectFriendViewController.h"
#import "PALFriend.h"
#import "PALMessage.h"
#import "UIViewController+PAL.h"
#import "PALMessengerHelper.h"

enum {
  SECTION_PROFILE,
  SECTION_INPUTS,
  SECTION_BUTTONS,
  SECTION_TOTAL
};

enum {
  INPUT_NOTIFICATION,
  INPUT_TEXT,
  INPUT_IMAGE_URL,
  INPUT_BUTTON_TEXT,
  INPUT_BUTTON_EXEC,
  INPUT_BUTTON_MARKET,
  INPUT_LINK_TEXT,
  INPUT_LINK_EXEC,
  INPUT_LINK_MARKET,
  INPUT_TOTAL
};

@interface SendMessageViewController()<UIActionSheetDelegate, UITextFieldDelegate, SelectFriendDelegate>
@property (nonatomic, strong) PALUser* user;
@property (nonatomic, strong) NSArray* labels;
@property (nonatomic, strong) NSArray* prefilledValues;
@property (nonatomic, strong) NSMutableArray* textFields;
@property (nonatomic, strong) NSMutableArray* checkable;
@property (nonatomic, strong) NSMutableArray* checked;
@end

@implementation SendMessageViewController

- (id) initSendMessage {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _user = nil;
    _labels = @[
        @"Notification",
        @"Text",
        @"Image",
        @"Button",
        @"Exec Params",
        @"Market Params",
        @"Link",
        @"Exec Params",
        @"Market Params"
    ];
    _prefilledValues = @[
        @"Notification",
        @"hello world",
        @"http://placehold.it/384x384",
        @"open app",
        @"click=button",
        @"via=sdk_button",
        @"go to app",
        @"click=link",
        @"via=sdk_link"
    ];
    _textFields = [NSMutableArray array];
    _checkable = [NSMutableArray array];
    _checked = [NSMutableArray array];
    for (int i = 0; i < INPUT_TOTAL; ++i) {
      [self.textFields addObject:[[UITextField alloc] initWithFrame:CGRectZero]];
      [_checkable addObject:[NSNumber numberWithBool:i == INPUT_TEXT
          || i == INPUT_IMAGE_URL
          || i == INPUT_BUTTON_TEXT
          || i == INPUT_LINK_TEXT]];
      [_checked addObject:[NSNumber numberWithBool:NO]];
    }
  }

  return self;
}

- (void) viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.title = @"Send Message";
  [self.navigationItem setHidesBackButton:YES animated:NO];
  [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]
      initWithTitle:@"Setting" style:UIBarButtonItemStylePlain target:self action:@selector(onSetting)]];
}

- (void) viewDidAppear:(BOOL) animated {
  [super viewDidAppear:animated];
  [self pal_didSessionChangedWithOpenSelector:@selector(loadProfile) withCloseSelector:@selector(goBackToMain)];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return SECTION_TOTAL;
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
  if (section == SECTION_INPUTS) {
    return INPUT_TOTAL;
  }
  return 1;
}

- (UITableViewCell*) createProfileCell:(UITableView*) tableView {
  static NSString* reuseId = @"ProfileCell";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
  }
  cell.textLabel.text = self.user.nickname;
  __weak UITableViewCell* weakCell = cell;
  [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.user.iconUrl]]
                        placeholderImage:nil
                                 success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                   weakCell.imageView.image = image;
                                   [weakCell setNeedsLayout];
                                 }
                                 failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {

                                 }];
  return cell;
}

- (UITableViewCell*) createInputCell:(UITableView*) tableView row:(NSUInteger) row {
  static NSString* reuseId = @"InputCell";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  if ([[cell.contentView subviews] count] == 0) {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    if ([self.checkable[row] boolValue]) {
      label.font = [UIFont boldSystemFontOfSize:14];
    } else {
      label.font = [UIFont systemFontOfSize:12];
    }
    label.textAlignment = NSTextAlignmentRight;
    label.text = [NSString stringWithFormat:@"%@:", self.labels[row]];
    [cell.contentView addSubview:label];
    UITextField* textField = self.textFields[row];
    textField.backgroundColor = [UIColor lightGrayColor];
    textField.font = [UIFont systemFontOfSize:12];
    textField.text = self.prefilledValues[row];
    textField.delegate = self;
    [Views resize:textField containerSize:CGSizeMake(cell.contentView.bounds.size.width - 100 - 44 - 5, 34)];
    [Views locate:textField x:110 y:5];
    [cell.contentView addSubview:textField];
    if (row == INPUT_TEXT || row == INPUT_NOTIFICATION) {
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
      self.checked[row] = [NSNumber numberWithBool:YES];
    }
  }

  return cell;
}

- (UITableViewCell*) createButtonCell:(UITableView*) tableView {
  static NSString* reuseId = @"ButtonCell";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
  }
  if ([[cell.contentView subviews] count] == 0) {
    UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton setTitle:@"Select a Friend to Send" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
    [Views resize:sendButton
    containerSize:CGSizeMake(cell.contentView.bounds.size.width - 10, cell.contentView.bounds.size.height - 10)];
    [Views locate:sendButton x:5 y:5];
    [cell.contentView addSubview:sendButton];
  }
  return cell;
}

- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  switch (indexPath.section) {
    case SECTION_PROFILE:
      return [self createProfileCell:tableView];
    case SECTION_INPUTS:
      return [self createInputCell:tableView row:(NSUInteger) indexPath.row];
    case SECTION_BUTTONS:
      return [self createButtonCell:tableView];
    default:
      return [super tableView:tableView cellForRowAtIndexPath:indexPath];
  }
}

- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

  if (indexPath.section != SECTION_INPUTS || indexPath.row == INPUT_NOTIFICATION) {
    return;
  }

  NSUInteger row = (NSUInteger) indexPath.row;
  while (![self.checkable[row] boolValue]) {
    --row;
  }

  UITableViewCell* cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:SECTION_INPUTS]];
  if (cell.accessoryType == UITableViewCellAccessoryNone) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.checked[row] = @YES;
  } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
    cell.accessoryType = UITableViewCellAccessoryNone;
    self.checked[row] = @NO;
  }
}

- (void) actionSheet:(UIActionSheet*) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
  NSString* button = [actionSheet buttonTitleAtIndex:buttonIndex];
  NSLog(@"SendMessageViewController actionSheet:%@", button);
  // right
  if ([button isEqualToString:@"Logout"]) {
    [self pal_disconnectWithCloseSelector:@selector(goBackToMain)];
  } else if ([button isEqualToString:@"Show Access Token"]) {
    NSLog(@"SendMessageViewController accessToken:%@ expire:%@",
        [[PALMessengerHelper getSession] getAccessToken],
        [NSDate dateWithTimeIntervalSince1970:[[PALMessengerHelper getSession] getExpireTime] / 1000]);
  } else if ([button isEqualToString:@"1 Hour Access Token"]) {
    [[PALMessengerHelper getSession] testMakeAccessTokenNeedToRefresh];
  } else if ([button isEqualToString:@"Invalidate Access Token"]) {
    [[PALMessengerHelper getSession] testInvalidAccessToken];
  }
}

- (void) onSend {
  if ([[self buildMessage] isEmpty]) {
    NSLog(@"SendMessageViewController message is empty");
    //        [self.view makeToast:@"cannot send an empty message" duration:1.5 position:@"top"];
    return;
  }

  SelectFriendViewController* selectFriendViewController = [[SelectFriendViewController alloc] initSelectFriend];
  selectFriendViewController.delegate = self;
  [self.navigationController pushViewController:selectFriendViewController animated:YES];
}

- (void) selectFriend:(PALFriend*) friend {
  [self.navigationController popViewControllerAnimated:YES];
  NSLog(@"SendMessageViewController selectFriend:%@", friend);
  [[PALSdk messenger] sendMessage:[self buildMessage] to:friend.uid done:^(NSError* error) {
    if (error) {
      NSLog(@"SendMessageViewController sendMessage failed:%@", error);
      //        [self.view makeToast:error.localizedDescription duration:1.5 position:@"top"];
      return;
    }
    NSLog(@"SendMessageViewController sendMessage successfully");
    //        [self.view makeToast:@"message sent successfully" duration:1.5 position:@"top"];
  }];
}

- (void) onSetting {
  UIActionSheet* actionSheet = [[UIActionSheet alloc]
         initWithTitle:nil
              delegate:self
     cancelButtonTitle:@"Cancel"
destructiveButtonTitle:@"Logout"
     otherButtonTitles:@"1 Hour Access Token",
                       @"Show Access Token",
                       @"Invalidate Access Token", nil];
  [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

- (void) loadProfile {
  NSLog(@"SendMessageViewController loadProfile");
  __weak SendMessageViewController* preventCircularRef = self;
  [[PALSdk messenger] requestMe:^(PALUser* user, NSError* error) {
    if (error) {
      NSLog(@"SendMessageViewController error:%@", error);
      return;
    }
    NSLog(@"SendMessageViewController loadProfile:%@", user);
    preventCircularRef.user = user;
    [self.tableView reloadData];
  }];
}

- (BOOL) textFieldShouldReturn:(UITextField*) textField {
  [textField resignFirstResponder];
  return YES;
}

- (void) goBackToMain {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (PALMessage*) buildMessage {
  PALMessageBuilder* builder = [PALMessageBuilder builder];
  if ([self.checked[INPUT_TEXT] boolValue]) {
    UITextField* inputText = self.textFields[INPUT_TEXT];
    [builder text:inputText.text];
  }
  if ([self.checked[INPUT_IMAGE_URL] boolValue]) {
    UITextField* inputImageUrl = self.textFields[INPUT_IMAGE_URL];
    [builder image:inputImageUrl.text];
  }
  if ([self.checked[INPUT_BUTTON_TEXT] boolValue]) {
    UITextField* inputButtonText = self.textFields[INPUT_BUTTON_TEXT];
    UITextField* inputButtonExec = self.textFields[INPUT_BUTTON_EXEC];
    UITextField* inputButtonMarket = self.textFields[INPUT_BUTTON_MARKET];
    [builder appButton:inputButtonText.text
                action:[[[PALMessageActionParams params]
                    executeParam:inputButtonExec.text]
                    marketParam:inputButtonMarket.text]];
  }
  if ([self.checked[INPUT_LINK_TEXT] boolValue]) {
    UITextField* inputLinkText = self.textFields[INPUT_LINK_TEXT];
    UITextField* inputLinkExec = self.textFields[INPUT_LINK_EXEC];
    UITextField* inputLinkMarket = self.textFields[INPUT_LINK_MARKET];
    [builder appLink:inputLinkText.text
              action:[[[PALMessageActionParams params]
                  executeParam:inputLinkExec.text]
                  marketParam:inputLinkMarket.text]];
  }
  UITextField* inputNotification = self.textFields[INPUT_NOTIFICATION];
  [builder notification:inputNotification.text];
  PALMessage* message = [builder build];
  return message;
}

@end
