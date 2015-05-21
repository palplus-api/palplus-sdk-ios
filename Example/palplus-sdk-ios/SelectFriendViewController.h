#import <Foundation/Foundation.h>

@class PALFriend;

@protocol SelectFriendDelegate<NSObject>
- (void) selectFriend:(PALFriend*) friend;
@end

@interface SelectFriendViewController : UITableViewController
@property (nonatomic, assign) id<SelectFriendDelegate> delegate;

- (id) initSelectFriend;
@end
