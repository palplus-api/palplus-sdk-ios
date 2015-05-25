#import <Foundation/Foundation.h>

@interface PALFriendsResult : NSObject
@property (nonatomic, readonly, strong) NSMutableArray* allFriends;

/**
* if true, PALMessenger.requestFriends: can be called with this object to obtain the next page of friends
*/
@property (nonatomic, readonly, assign) BOOL hasMore;

+ (instancetype) list;

- (void) update:(NSArray*) friends;
@end
