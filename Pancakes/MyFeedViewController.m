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
#import "MainViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utils.h"
#import "UserDataHolder.h"

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
    
    self.constraintY.constant = kMenuBarHeigth;
}

- (void)viewWillAppear:(BOOL)animated {
    MainViewController* parent = (MainViewController*)self.parentViewController.parentViewController; // get the main view controller
    
    // back from article view ?
    if (parent.menuItem.frame.origin.x < 0) {
        CGRect f = self.feedTableView.frame;
        f.origin.x = - self.view.frame.size.width/2;
        self.feedTableView.frame = f;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect f = parent.menuTopBar.frame;
            f.origin.x += self.view.frame.size.width/2;
            [parent.menuTopBar setFrame:f];
            f = parent.menuItem.frame;
            f.origin.x += self.view.frame.size.width/2;
            [parent.menuItem setFrame:f];
            f = self.feedTableView.frame;
            f.origin.x = 0.0f;
            self.feedTableView.frame = f;
        } completion:nil];
    }
}

- (void)fetchFeed {
    UserDataHolder* holder = [UserDataHolder sharedInstance];
    [holder loadData];
    
    NSString* feedUrl = @"";
    
    if (holder.user._id != nil) {
        NSString* userId = holder.user._id;
        feedUrl = [kApiRootUrl stringByAppendingString:[NSString stringWithFormat:@"/user/%@/feed", userId]];
    } else {
        // if no user, use public articles feed
        feedUrl = [kApiRootUrl stringByAppendingString:@"/articles"];
    }
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:feedUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError* err = nil;
        feedArticles = [Article arrayOfModelsFromData:data error:&err];
        
        if (err != nil) {
            NSLog(@"%@", err);
        }
        
        // Reload table data on main thread to avoid problems
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.feedTableView reloadData];
            NSIndexPath* firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            [self.feedTableView selectRowAtIndexPath:firstIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:self.feedTableView didSelectRowAtIndexPath:firstIndexPath];
            
        });
        
    }] resume];
}

#pragma mark - Helpers

- (NSString*)excerptOfContent:(NSString*)content firstWordsCount:(NSInteger)nWords {
    NSRange wordRange = NSMakeRange(0, nWords);
    NSArray *firstWords = [[content componentsSeparatedByString:@" "] subarrayWithRange:wordRange];
    
    return [[firstWords componentsJoinedByString:@" "] stringByAppendingString:@" (...)"];
}

#pragma mark - Actions

- (IBAction)displaySelectedArticle:(id)sender {
    
    MainViewController* parent = (MainViewController*)self.parentViewController.parentViewController; // get the main view controller
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect f = self.feedTableView.frame;
        f.origin.x = -self.view.frame.size.width/2;
        [self.feedTableView setFrame:f];
        f = self.articleExcerpt.frame;
        f.origin.y = self.view.frame.size.height;
        [self.articleExcerpt setFrame:f];
        f = parent.menuTopBar.frame;
        f.origin.x -= self.view.frame.size.width/2;
        [parent.menuTopBar setFrame:f];
        f = parent.menuItem.frame;
        f.origin.x -= self.view.frame.size.width/2;
        [parent.menuItem setFrame:f];
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
    feedCellTitle.font = [UIFont fontWithName:kFontBreeBold size:15];
    feedCellTitle.textColor = kFeedViewListTitleColor;
    
    UIImageView* feedCellThumb = (UIImageView*)[cell.contentView viewWithTag:20];
    [feedCellThumb setFrame:CGRectMake(feedCellThumb.frame.origin.x, feedCellThumb.frame.origin.y, cell.frame.size.width/3.5, cell.frame.size.height)];
    [feedCellThumb sd_setImageWithURL:[NSURL URLWithString:article.coverImage]];
    feedCellThumb.clipsToBounds = YES;
    
    UILabel* themeTitle = (UILabel*)[cell.contentView viewWithTag:50];
    themeTitle.textColor = [Utils colorWithHexString:article.color];
    
    UIImageView* check = [[UIImageView alloc] initWithFrame:CGRectMake(38.0f, 38.0f, 22.0f, 15.0f)];
    check.image = [UIImage imageNamed:@"check_item"];
    check.tintColor = [UIColor whiteColor];
    check.contentMode = UIViewContentModeScaleAspectFit;
    check.tag = 50;
    check.alpha = 0.0f;
    
    UIImageView* zigzag = (UIImageView*)[cell.contentView viewWithTag:60];
    zigzag.image = [zigzag.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [zigzag setTintColor:[Utils colorWithHexString:article.color]];
    
    [overlay addSubview:check];
    
    [cell setNeedsLayout];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Article* article = [feedArticles objectAtIndex:[indexPath row]];
    
    selectedArticle = article;
    
    [self.selectedArticleCover sd_setImageWithURL:[NSURL URLWithString:article.coverImage]];
    self.selectedArticleCover.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // ... Yes, that's dirty
    Block* firstBlock = (Block*)article.blocks[1];
    NSString* content = firstBlock.paragraphs[0];
    ContentParser* parser = [[ContentParser alloc] init];
    self.articleExcerpt.text = [self excerptOfContent:[parser getCleanedString:content] firstWordsCount:22];
    self.articleExcerpt.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    self.articleExcerpt.alpha = 0.0f;
    
    UIView* overlay = [cell.contentView viewWithTag:5];
    UIView* check = [overlay viewWithTag:50];
    check.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.selectedArticleCover.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        cell.backgroundColor = RgbaColor(0, 0, 0, 0);
        cell.contentView.backgroundColor = RgbaColor(0, 0, 0, 0);
        self.articleExcerpt.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.articleExcerpt.alpha = 1.0f;
        overlay.hidden = NO;
        
        check.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        check.alpha = 1.0f;
    } completion:nil];
    
    UILabel* feedCellTitle = (UILabel*)[cell.contentView viewWithTag:10];
    feedCellTitle.textColor = [UIColor whiteColor];
    [cell.contentView bringSubviewToFront:feedCellTitle];
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = kArticleViewBlockBackground;
    
    UILabel* feedCellTitle = (UILabel*)[cell.contentView viewWithTag:10];
    feedCellTitle.textColor = kFeedViewListTitleColor;
    
    UIView* overlay = [cell.contentView viewWithTag:5];
    overlay.hidden = YES;
    UIView* check = [overlay viewWithTag:50];
    check.alpha = 0.0f;
}




@end
