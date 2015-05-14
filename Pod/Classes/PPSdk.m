//
// Created by ingram on 5/12/15.
// Copyright (c) 2015 Ingram Chen. All rights reserved.
//

#import "PPSdk.h"
#import "PPForum.h"

@implementation PPSdk

+ (PPForum*) forum {
  static PPForum* forum = nil;
  @synchronized ([PPSdk class]) {
    if (!forum) {
      forum = [[PPForum alloc] init];
    }
  }
  return forum;
}

@end