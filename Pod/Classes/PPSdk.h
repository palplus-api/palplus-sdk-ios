//
// Created by ingram on 5/12/15.
// Copyright (c) 2015 Ingram Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPForum;

@interface PPSdk : NSObject

@property (nonatomic, readonly, strong) PPForum* forum;

+(PPForum* ) forum;
@end