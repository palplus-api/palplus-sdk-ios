#import "PPForum.h"

// helper function: get the string form of any object
static NSString* toString(id object) {
  return [NSString stringWithFormat:@"%@", object];
}

static NSString* urlEncode(id object) {
  NSString* string = toString(object);
  return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

static id nsNullSafe(id any) {
  if (any == nil) {
    return [NSNull null];
  }
  return any;
}

@implementation PPForum

+ (NSString*) encodeParams:(NSDictionary*) params {
  NSMutableArray* parts = [NSMutableArray array];
  for (id key in params) {
    id value = params[key];
    if (value == [NSNull null]) {
      continue;
    }
    NSString* part = [NSString stringWithFormat:@"%@=%@", urlEncode(key), urlEncode(value)];
    [parts addObject:part];
  }
  return [parts componentsJoinedByString:@"&"];
}

+ (NSURL*) openBoardUrl:(NSString*) boardId {
  return [NSURL URLWithString:[NSString stringWithFormat:@"palplus-sdk://forum/board/%@", boardId]];
}

- (BOOL) canOpenBoard:(NSString*) boardId {
  return [[UIApplication sharedApplication] canOpenURL:[PPForum openBoardUrl:boardId]];
}

- (void) openBoard:(NSString*) boardId {
  [[UIApplication sharedApplication] openURL:[PPForum openBoardUrl:boardId]];
}

+ (NSURL*) createArticleUrl:(NSString*) boardId withTitle:(NSString*) title withImage:(UIImage*) image {
  NSString* imagePath = nil;
  if (image) {
    NSData* imageData = UIImageJPEGRepresentation(image, 0.35f);
    NSString* writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"palplus-sdk-create-article.jpg"];
    [imageData writeToFile:writePath atomically:YES];
    imagePath = [[NSURL fileURLWithPath:writePath] absoluteString];
  }
  NSDictionary* params = @{@"boardId" : boardId, @"title" : nsNullSafe(title), @"image" : nsNullSafe(imagePath)};
  return [NSURL URLWithString:[NSString stringWithFormat:@"palplus-sdk://forum/createArticle/?%@",
                                                         [self encodeParams:params]]];
}

- (BOOL) canCreateArticle:(NSString*) boardId {
  return [[UIApplication sharedApplication] canOpenURL:[PPForum createArticleUrl:boardId withTitle:nil withImage:nil]];
}

- (void) createArticle:(NSString*) boardId withTitle:(NSString*) title withImage:(UIImage*) image {
  [[UIApplication sharedApplication] openURL:[PPForum createArticleUrl:boardId withTitle:title withImage:image]];
}

@end