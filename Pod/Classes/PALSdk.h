//
// Created by ingram on 5/12/15.
// Copyright (c) 2015 Ingram Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PALForum;
@protocol PALMessenger;

@interface PALSdk : NSObject

/**
* return the entry of Forum API
*/
+ (PALForum*) forum;

/**
* return the entry of Messenger API
*/
+ (id<PALMessenger>) messenger;

/**
* Initialize Pal+ SDK, should invoke when app start. appKey is required for Messenger API only
*/
+ (void) setup:(NSString*) appKey;

/**
* this method should be called in UIApplicationDelegate as below to facilitate interaction with Pal+ app
*
- (BOOL) application:(UIApplication*) application
openURL:(NSURL*) url
sourceApplication:(NSString*) sourceApplication
annotation:(id) annotation {
return [PALSdk handleOpenUrl:url sourceApplication:sourceApplication];
}
*/
+ (BOOL) handleOpenUrl:(NSURL*) url sourceApplication:(NSString*) sourceApplication;

@end