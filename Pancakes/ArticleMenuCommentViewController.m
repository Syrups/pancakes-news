//
//  ArticleMenuCommentViewController.m
//  Pancakes
//
//  Created by Leo on 13/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ArticleMenuCommentViewController.h"
#import "ArticleViewController.h"
#import "Configuration.h"
#import <JSONModel/JSONHTTPClient.h>
#import "UserDataHolder.h"

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

- (IBAction)postComment:(UITextField*)sender {
    
//    NSString* userId = [[UserDataHolder sharedInstance] user]._id;
    NSString* userId = @"5440e462d1e57b5861b503d3";
    
    ArticleViewController* articleVc = (ArticleViewController*)self.parentViewController.parentViewController;
    
    NSDictionary *params = @{
        @"user_id": userId,
        @"content": sender.text
    };

    //make post, get requests
    [JSONHTTPClient postJSONFromURLWithString:[kApiRootUrl stringByAppendingString:[NSString stringWithFormat:@"/articles/%@/comments", articleVc.displayedArticle._id]]
                                       params:params
                                   completion:^(id json, JSONModelError *err) {
                                       
                                       NSLog(@"Response : %@", json);
                                       
                                       if (err == nil) {
                                           [self dismiss:nil];
                                       }
                                       
    }];
}

@end
