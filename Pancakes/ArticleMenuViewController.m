//
//  ArticleMenuViewController.m
//  Pancakes
//
//  Created by Leo on 10/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ArticleMenuViewController.h"
#import "ArticleViewController.h"

@interface ArticleMenuViewController ()

@end

@implementation ArticleMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailViewControllers = @{
        @"10": [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleMenuInterestsView"],
        @"20": [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleMenuShareView"],
        @"30": [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleMenuRelatedView"],
        @"40": [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleMenuCommentView"]
    };
}

- (IBAction)didSelectItem:(UIButton*)sender {
    NSString* tag = [NSString stringWithFormat:@"%d", sender.tag];
    UIViewController* destination = [self.detailViewControllers objectForKey:tag];
    ArticleViewController* parent = (ArticleViewController*)self.parentViewController;
    
    // remove selected state for other items
    for (UIView* v in self.view.subviews) {
        if (v.class == [UIButton class]) {
            [(UIButton*)v setSelected:NO];
        }
    }
    
    // set this item selected
    sender.selected = YES;
    
    if (destination != nil) {
        [parent.menuDetailViewController setViewControllers:@[destination] animated:YES];
    }
}

- (IBAction)closeMenu:(id)sender {
    ArticleViewController* parent = (ArticleViewController*)self.parentViewController;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.view.frame;
        frame.origin.x = parent.view.frame.size.width;
        self.view.frame = frame;
        
        frame = parent.menuDetailViewController.view.frame;
        frame.origin.x = - self.view.frame.size.width;
        parent.menuDetailViewController.view.frame = frame;
    } completion:nil];
}

@end
