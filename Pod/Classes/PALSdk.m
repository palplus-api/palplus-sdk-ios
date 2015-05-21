//
// Created by ingram on 5/12/15.
// Copyright (c) 2015 Ingram Chen. All rights reserved.
//

#import "PALSdk.h"
#import "PALForum.h"
#import "PALTracker.h"
#import "PALPref.h"
#import "PALMessenger.h"

static PALMessenger* messenger = nil;

@implementation PALSdk

+ (PALForum*) forum {
  static PALForum* forum = nil;
  @synchronized ([PALSdk class]) {
    if (!forum) {
      forum = [[PALForum alloc] init];
    }
  }
  return forum;
}

+ (PALMessenger*) messenger {
  if (!messenger) {
    [[[UIAlertView alloc]
        initWithTitle:@"WARNING"
              message:@"You have to initialize SDK by using [PALSdk setup:@\"__YOUR_APP_KEY__\"] first"
             delegate:nil
    cancelButtonTitle:@"OK"
    otherButtonTitles:nil]
        show];
  }
  return messenger;
}

+ (void) setup:(NSString*) appKey {
  if (appKey) {
    @synchronized ([PALSdk class]) {
      if (!messenger) {
        messenger = [[PALMessenger alloc] initWithAppKey:appKey];
      }
    }
  }

  if ([[PALPref sharedInstance] isStopQueue]) {
    return;
  }
  dispatch_queue_t queue = dispatch_queue_create("me.palplus.sdk", DISPATCH_QUEUE_SERIAL);
  dispatch_async(queue, ^{ // 1
    [[[PALTracker alloc] init] start];
  });
}

@end