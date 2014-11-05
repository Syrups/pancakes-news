//
//  MyFeedViewController.m
//  Pancakes
//
//  Created by Leo on 24/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "MyFeedViewController.h"
#import <JSONModel/JSONHTTPClient.h>
#import "Article.h"
#import "Configuration.h"
#import "ArticleViewController.h"
#import "MainMenuViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MyFeedViewController {
    NSArray* feedArticles;
    Article* selectedArticle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchFeed];
    [self.view bringSubviewToFront:self.feedTableView];
    
    self.feedTableView.layoutMargins = UIEdgeInsetsZero;
    self.feedTableView.contentMode = UIViewContentModeScaleAspectFill;
    [self.feedTableView setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width/2, self.view.frame.size.height)];
    
    [self createMainMenu];
}

- (void)fetchFeed {
    NSString *feedUrl = [kApiRootUrl stringByAppendingString:@"/feed"];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:feedUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError* err = nil;
        feedArticles = [Article arrayOfModelsFromData:data error:&err];
        
        // Reload table data on main thread to avoid problems
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.feedTableView reloadData];
        });
        
    }] resume];
}

#pragma mark - Helpers

- (void) createMainMenu {
    MainMenuViewController* menuVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    menuVc.currentViewController = self;
    [self addChildViewController:menuVc];
    [menuVc didMoveToParentViewController:self];
    menuVc.view.frame = CGRectMake(-self.view.frame.size.width/2, 0.0f, self.view.frame.size.width/2, self.view.frame.size.height);
    [self.view addSubview:menuVc.view];
    self.mainMenu = menuVc;
}

#pragma mark - Actions

- (IBAction)toggleMainMenu:(id)sender {
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.mainMenu.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width/2, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.mainMenu animateOpening];
    }];
}

- (IBAction)displaySelectedArticle:(id)sender {
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect f = self.feedTableView.frame;
        f.origin.x = -self.view.frame.size.width/2;
        [self.feedTableView setFrame:f];
        f = self.topBar.frame;
        f.origin.x = -self.view.frame.size.width/2;
        [self.topBar setFrame:f];
    } completion:^(BOOL finished) {
        
        ArticleViewController* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ArticleViewController"];
        vc.displayedArticle = selectedArticle;
        vc.articleCoverImage = [[UIImageView alloc] initWithFrame:self.view.frame];
        [vc.articleCoverImage sd_setImageWithURL:[NSURL URLWithString:selectedArticle.coverImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil) {
                vc.cover = image;
                [self.navigationController pushViewController:vc animated:NO];
            }
        }];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feedArticles count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height/3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.feedTableView dequeueReusableCellWithIdentifier:@"FeedArticleCell"];
    cell.contentView.backgroundColor = kArticleViewBlockBackground;
    
    Article* article = [feedArticles objectAtIndex:[indexPath row]];
    
    if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FeedArticleCell"];
    }
    
    UIView* overlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width/2, self.view.frame.size.height/3)];
    overlay.tag = 5;
    overlay.backgroundColor = RgbaColor(0, 0, 0, 0.6f);
    overlay.hidden = YES;
    [cell.contentView addSubview:overlay];
    
    UILabel* feedCellTitle = (UILabel*)[cell.contentView viewWithTag:10];
    feedCellTitle.text = article.title;
    feedCellTitle.font = [UIFont fontWithName:kFontBreeBold size:16];
    feedCellTitle.textColor = kFeedViewListTitleColor;
    
    UIImageView* feedCellThumb = (UIImageView*)[cell.contentView viewWithTag:20];
    [feedCellThumb sd_setImageWithURL:[NSURL URLWithString:article.coverImage]];
    
    [cell setNeedsLayout];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Article* article = [feedArticles objectAtIndex:[indexPath row]];
    
    selectedArticle = article;
    
    [self.selectedArticleCover sd_setImageWithURL:[NSURL URLWithString:article.coverImage]];
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = RgbaColor(0, 0, 0, 0);
    cell.contentView.backgroundColor = RgbaColor(0, 0, 0, 0);
    
    UILabel* feedCellTitle = (UILabel*)[cell.contentView viewWithTag:10];
    feedCellTitle.textColor = [UIColor whiteColor];
    
    UIView* overlay = [cell.contentView viewWithTag:5];
    overlay.hidden = NO;
    
    [cell.contentView bringSubviewToFront:feedCellTitle];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = kArticleViewBlockBackground;
    
    UILabel* feedCellTitle = (UILabel*)[cell.contentView viewWithTag:10];
    feedCellTitle.textColor = kFeedViewListTitleColor;
    
    UIView* overlay = [cell.contentView viewWithTag:5];
    overlay.hidden = YES;
}

#pragma mark - MainMenuDisplayer

- (void)closeMainMenu {
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.mainMenu.view.frame = CGRectMake(-self.view.frame.size.width/2, 0.0f, self.view.frame.size.width/2, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.mainMenu animateClosing];
    }];

}

@end
