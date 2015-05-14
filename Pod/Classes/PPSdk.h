//
// Created by ingram on 5/12/15.
// Copyright (c) 2015 Ingram Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPForum;

@interface PPSdk : NSObject

+(PPForum* ) forum;

+ (void) setup;
@end