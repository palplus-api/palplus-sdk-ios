//
// Created by ingram on 5/12/15.
// Copyright (c) 2015 Ingram Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PALForum;
@protocol PALMessenger;

@interface PALSdk : NSObject

+ (PALForum*) forum;

+ (id<PALMessenger>) messenger;

+ (void) setup:(NSString*) appKey;

@end