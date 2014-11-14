//
//  ArticleMenuCommentViewController.m
//  Pancakes
//
//  Created by Leo on 13/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ArticleMenuCommentViewController.h"
#import "ArticleViewController.h"

@interface ArticleMenuCommentViewController ()

@end

@implementation ArticleMenuCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentField.borderStyle = UITextBorderStyleRoundedRect;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.commentField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.commentField resignFirstResponder];
}

- (IBAction)dismiss:(id)sender {
    ArticleViewController* articleVc = (ArticleViewController*)self.navigationController.parentViewController;
    // fake button call
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = 10;
    
    [articleVc.menuViewController didSelectItem:btn];
}

@end
