//
//  ChooseThemesViewController.m
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ChooseThemesViewController.h"

@interface ChooseThemesViewController ()

@end

@implementation ChooseThemesViewController {
    NSMutableArray* categoriesViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height)];
    
    [self loadCategoriesScrollView];
}

- (void)loadCategoriesScrollView {
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    NSInteger numberOfViews = 3;
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * self.scrollView.frame.size.height;
        UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(0, xOrigin, self.view.frame.size.width/2, self.view.frame.size.height)];
        awesomeView.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
        [self.scrollView addSubview:awesomeView];
        [categoriesViews addObject:awesomeView];
    }
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width / 2, self.view.frame.size.height * numberOfViews);
    
    [self.view addSubview:self.scrollView];
}

- (UIView*) getCurrentDisplayedView {
    CGFloat width = self.scrollView.frame.size.height;
    NSUInteger page = (self.scrollView.contentOffset.y + (0.5f * width)) / width;
    
    return [categoriesViews objectAtIndex:page];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.scrollView.frame.size.height;
    NSUInteger page = (self.scrollView.contentOffset.y + (0.5f * width)) / width;
    
    [self.currentPageNum setText:[NSString stringWithFormat:@"%lu", page]];
}
@end
