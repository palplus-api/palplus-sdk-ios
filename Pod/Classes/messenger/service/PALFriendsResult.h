#import <Foundation/Foundation.h>

@interface PALFriendsResult : NSObject
@property (nonatomic, readonly, strong) NSMutableArray* allFriends;
@property (nonatomic, readonly, assign) BOOL hasMore;

+ (instancetype) list;

- (void) update:(NSArray*) friends;
@end
