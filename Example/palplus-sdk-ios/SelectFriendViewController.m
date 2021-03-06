#import "PALSdk.h"
#import "SelectFriendViewController.h"
#import "PALFriendsResult.h"
#import "PALFriend.h"
#import "PALMessenger.h"
#import "UIImageView+AFNetworking.h"
#import "Views.h"

enum {
  SECTION_FRIENDS,
  SECTION_MORE,
  SECTION_TOTAL
};

@interface SelectFriendViewController()<UIAlertViewDelegate>
@property (nonatomic, strong) UIActivityIndicatorView* loading;
@property (nonatomic, strong) PALFriendsResult* friendList;
@property (nonatomic, strong) PALFriend* selectedFriend;
@end

@implementation SelectFriendViewController

- (id) initSelectFriend {
  self = [super init];
  if (self) {
    _friendList = [PALFriendsResult list];
  }

  return self;
}

- (void) viewDidLoad {
  [super viewDidLoad];

  _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [self.loading startAnimating];
  [self.loading sizeToFit];
  [Views alignCenterMiddle:self.loading containerFrame:self.view.frame];
  [self.view addSubview:self.loading];
  [self loadFriends];
}

- (void) goBackToMain {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return SECTION_TOTAL;
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
  switch (section) {
    case SECTION_FRIENDS:
      return self.friendList.allFriends.count;
    case SECTION_MORE:
      return self.friendList.allFriends.count == 0 || !self.friendList.hasMore ? 0 : 1;
    default:
      return 0;
  }
}

- (UITableViewCell*) friendCell:(UITableView*) tableView row:(NSInteger) row {
  static NSString* reuseId = @"FriendCell";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
  }
  PALFriend* friend = self.friendList.allFriends[row];
  cell.textLabel.text = friend.nickname;
  cell.imageView.image = nil;
  __weak UITableViewCell* weakCell = cell;
  [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:friend.iconUrl]]
                        placeholderImage:nil
                                 success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                   weakCell.imageView.image = image;
                                   [weakCell setNeedsLayout];
                                 }
                                 failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {

                                 }];
  return cell;
}

- (UITableViewCell*) moreCell:(UITableView*) tableView {
  static NSString* reuseId = @"MoreCell";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
  }
  if ([[cell.contentView subviews] count] == 0) {
    UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton setTitle:@"More" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(onMore) forControlEvents:UIControlEventTouchUpInside];
    [Views resize:sendButton
    containerSize:CGSizeMake(cell.contentView.bounds.size.width - 10, cell.contentView.bounds.size.height - 10)];
    [Views locate:sendButton x:5 y:5];
    [cell.contentView addSubview:sendButton];
  }
  return cell;
}

- (void) onMore {
  [self loadFriends];
}

- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  switch (indexPath.section) {
    case SECTION_FRIENDS:
      return [self friendCell:tableView row:indexPath.row];
    case SECTION_MORE:
      return [self moreCell:tableView];
    default:
      return [super tableView:tableView cellForRowAtIndexPath:indexPath];
  }
}

- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (self.delegate && [self.delegate respondsToSelector:@selector(selectFriend:)]) {
    self.selectedFriend = self.friendList.allFriends[(NSUInteger) indexPath.row];
    [[[UIAlertView alloc]
        initWithTitle:nil
              message:[NSString stringWithFormat:@"Send message to %@?", self.selectedFriend.nickname]
             delegate:self
    cancelButtonTitle:@"Cancel"
    otherButtonTitles:@"Send", nil]
        show];
  }
}

- (void) alertView:(UIAlertView*) alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
  if (buttonIndex != alertView.cancelButtonIndex) {
    [self.delegate selectFriend:self.selectedFriend];
  }
}

- (void) loadFriends {
  __weak SelectFriendViewController* preventCircularRef = self;
  [[PALSdk messenger]
      requestFriends:self.friendList
            pageSize:25
                done:^(PALFriendsResult* updatedFriendList, NSError* error) {
                  [preventCircularRef.loading stopAnimating];
                  if (error) {
                    NSLog(@"SelectFriendViewController loadFriends error:%@", error);
                    return;
                  }
                  NSLog(@"SelectFriendViewController loadFriends success:%@", updatedFriendList);
                  preventCircularRef.friendList = updatedFriendList;
                  [preventCircularRef.tableView reloadData];
                }];
}

@end
