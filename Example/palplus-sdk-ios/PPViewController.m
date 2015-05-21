//
//  PPViewController.m
//  PalplusSDK
//
//  Created by Ingram Chen on 05/12/2015.
//  Copyright (c) 2014 Ingram Chen. All rights reserved.
//

#import "PPViewController.h"
#import "PALSdk.h"
#import "PALForum.h"
#import "MessengerViewController.h"

static NSString* const BOARD_ID = @"cd1ec670-ab5a-11e4-9e3a-25191cafc7c9";

@interface PPViewController()<UIDocumentInteractionControllerDelegate>

@end

@implementation PPViewController

- (UIButton*) createButton:(NSString*) title y:(CGFloat) y {
  UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
  [button setTitle:title forState:UIControlStateNormal];
  [button sizeToFit];
  button.frame = CGRectMake(50, y, button.frame.size.width, button.frame.size.height);
  return button;

}

- (void) viewDidLoad {
  [super viewDidLoad];
  UIButton* messengerButton = [self createButton:@"Messenger" y:100];
  [messengerButton addTarget:self action:@selector(onMessenger) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:messengerButton];

  UIButton* goToBoardButton = [self createButton:@"Go to board" y:150];
  [goToBoardButton addTarget:self action:@selector(onOpenBoard) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:goToBoardButton];

  UIButton* createArticleButton = [self createButton:@"Create article" y:200];
  [createArticleButton addTarget:self action:@selector(onCreateArticle) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:createArticleButton];

  UIButton* createArticleWithTextButton = [self createButton:@"Create article with text" y:250];
  [createArticleWithTextButton addTarget:self
                                  action:@selector(onCreateArticleWithText)
                        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:createArticleWithTextButton];

  UIButton* createArticleWithImageButton = [self createButton:@"Create article with image" y:300];
  [createArticleWithImageButton addTarget:self
                                   action:@selector(onCreateArticleWithImage)
                         forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:createArticleWithImageButton];

  UIButton* createArticleWithTextAndImageButton = [self createButton:@"Create article with text and image" y:350];
  [createArticleWithTextAndImageButton addTarget:self
                                          action:@selector(onCreateArticleWithTextAndImage)
                                forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:createArticleWithTextAndImageButton];
}

- (void) onMessenger {
  MessengerViewController* controller = [[MessengerViewController alloc] initMessenger];
  [self.navigationController pushViewController:controller animated:YES];
}

- (void) onOpenBoard {
  if ([[PALSdk forum] canOpenBoard:BOARD_ID]) {
    [[PALSdk forum] openBoard:BOARD_ID];
  } else {
    NSLog(@"please install pal+ first");
  }
}

- (void) onCreateArticle {
  if ([[PALSdk forum] canCreateArticle:BOARD_ID]) {
    [[PALSdk forum] createArticle:BOARD_ID withTitle:nil withImage:nil];
  } else {
    NSLog(@"please install pal+ first");
  }
}

- (void) onCreateArticleWithText {
  if ([[PALSdk forum] canCreateArticle:BOARD_ID]) {
    [[PALSdk forum] createArticle:BOARD_ID withTitle:@"hello" withImage:nil];
  } else {
    NSLog(@"please install pal+ first");
  }
}

- (void) onCreateArticleWithImage {
  if ([[PALSdk forum] canCreateArticle:BOARD_ID]) {
    [[PALSdk forum] createArticle:BOARD_ID withTitle:nil withImage:[self createTestImage:@"screenshot"]];
  } else {
    NSLog(@"please install pal+ first");
  }
}

- (void) onCreateArticleWithTextAndImage {
  if ([[PALSdk forum] canCreateArticle:BOARD_ID]) {
    [[PALSdk forum] createArticle:BOARD_ID withTitle:@"hello" withImage:[self createTestImage:@"sample_image"]];
  } else {
    NSLog(@"please install pal+ first");
  }
}

- (UIImage*) createTestImage:(NSString*) name {
  return [UIImage imageNamed:name];
}

@end
