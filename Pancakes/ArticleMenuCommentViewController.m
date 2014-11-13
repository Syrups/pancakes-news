//
//  ArticleMenuCommentViewController.m
//  Pancakes
//
//  Created by Leo on 13/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ArticleMenuCommentViewController.h"

@interface ArticleMenuCommentViewController ()

@end

@implementation ArticleMenuCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentField.borderStyle = UITextBorderStyleRoundedRect;
    [self.commentField becomeFirstResponder];
}


@end
