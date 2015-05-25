//
//  PPAppDelegate.m
//  PalplusSDK
//
//  Created by CocoaPods on 05/12/2015.
//  Copyright (c) 2014 Ingram Chen. All rights reserved.
//

#import "PPAppDelegate.h"
#import "PALSdk.h"
#import "PPViewController.h"
#import "PALMessengerDelegate.h"
#import "PALMessenger.h"

@interface PPAppDelegate()<PALMessengerDelegate>
@end

@implementation PPAppDelegate

- (void) pal_messengerConnectionInvalidated:(id<PALMessenger>) messenger {
  NSLog(@"messenger connection invalidated, You should redirect user to connect Pal+ again");
}

- (void) pal_messenger:(id<PALMessenger>) messenger didOpenWithExecuteParams:(NSString*) params {
  [[[UIAlertView alloc]
      initWithTitle:@"Detected"
            message:[NSString stringWithFormat:@"Execute Parameters from Pal+: %@", params]
           delegate:nil
  cancelButtonTitle:@"OK"
  otherButtonTitles:nil]
      show];
}

- (BOOL) application:(UIApplication*) application didFinishLaunchingWithOptions:(NSDictionary*) launchOptions {

  // Required only for Messenger API, check Pal+ developer console for your own
  NSString* appKey = @"494c81669a4d3cccb906";
  [PALSdk setup:appKey];
  [PALSdk messenger].delegate = self;

  [self createDemoWindow];
  return YES;
}

- (void) createDemoWindow {
  PPViewController* mainViewController = [[PPViewController alloc] initWithNibName:nil bundle:nil];
  UINavigationController* mainNavController = [[UINavigationController alloc]
      initWithRootViewController:mainViewController];

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = mainNavController;
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];

#if TARGET_IPHONE_SIMULATOR
  [[[UIAlertView alloc]
      initWithTitle:@"WARNING"
            message:@"Pal+ SDK Demo only work in real iOS device. Simulator is not supported."
           delegate:nil
  cancelButtonTitle:@"OK"
  otherButtonTitles:nil] show];
#endif

}

- (BOOL) application:(UIApplication*) application
             openURL:(NSURL*) url
   sourceApplication:(NSString*) sourceApplication
          annotation:(id) annotation {
  return [PALSdk handleOpenUrl:url sourceApplication:sourceApplication];
}

@end
