//
// Created by ingram on 5/12/15.
// Copyright (c) 2015 Ingram Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PALForum;
@class PALMessenger;

@interface PALSdk : NSObject

+ (PALForum*) forum;

+ (PALMessenger*) messenger;

+ (void) setup:(NSString*) appKey;

@end