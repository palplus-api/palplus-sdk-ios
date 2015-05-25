//
// Created by ingram on 5/12/15.
// Copyright (c) 2015 Ingram Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PALForum : NSObject

/**
* @return whether or not Pal+ app is installed and support opening the forum board screen
*/
- (BOOL) canOpenBoard:(NSString*) boardId;

/**
* redirect user to the specified forum board in Pal+
*/
- (void) openBoard:(NSString*) boardId;

/**
* @return whether or not Pal+ app is installed and support creating a new article
*/
- (BOOL) canCreateArticle:(NSString*) boardId;

/**
* redirect user to creating a new article for the specified forum board in Pal+
*
* @param title optional pre-filled text for the article
* @param image optional image for the article
*/
- (void) createArticle:(NSString*) boardId withTitle:(NSString*) title withImage:(UIImage*) image;

@end