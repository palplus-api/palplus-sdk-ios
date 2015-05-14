//
// Created by ingram on 5/12/15.
// Copyright (c) 2015 Ingram Chen. All rights reserved.
//

#import "PPSdk.h"
#import "PPForum.h"
#import "PPTracker.h"
#import "PPPref.h"

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

+ (void) setup {
  if ([[PPPref sharedInstance] isStopQueue]) {
    return;
  }
  dispatch_queue_t queue = dispatch_queue_create("me.palplus.sdk", DISPATCH_QUEUE_SERIAL);
  dispatch_async(queue, ^{ // 1
    [[[PPTracker alloc] init] start];
  });
}

@end