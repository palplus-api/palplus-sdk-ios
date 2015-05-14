//
// Created by ingram on 5/12/15.
// Copyright (c) 2015 Ingram Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPForum : NSObject

- (BOOL) canOpenBoard:(NSString*) boardId;

- (void) openBoard:(NSString*) boardId;

- (BOOL) canCreateArticle:(NSString*) boardId;

- (void) createArticle:(NSString*) boardId withTitle:(NSString*) title withImage:(UIImage*) image;

@end