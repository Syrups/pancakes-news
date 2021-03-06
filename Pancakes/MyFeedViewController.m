//
//  MyFeedViewController.m
//  Pancakes
//
//  Created by Leo on 24/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "MyFeedViewController.h"
#import <JSONModel/JSONHTTPClient.h>
#import "Configuration.h"
#import "ArticleViewController.h"
#import "MainMenuViewController.h"
#import "MainViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserDataHolder.h"
#import "Services.h"
#import "Models.h"

@implementation MyFeedViewController {
    NSArray* feedArticles;
    Article* selectedArticle;
    BOOL switchingView;
    BOOL touchEnabled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadWaitingScreen];
    
    [self fetchFeed];
//    [self.view bringSubviewToFront:self.feedTableView];
    
    self.feedTableView.layoutMargins = UIEdgeInsetsZero;
    self.feedTableView.contentMode = UIViewContentModeScaleAspectFill;
    self.feedTableView.hidden = YES;
    
    
    self.constraintY.constant = kMenuBarHeigth;
    
    touchEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"menu.open" object:nil queue:nil usingBlock:^(NSNotification *note) {
        touchEnabled = NO;
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"menu.close" object:nil queue:nil usingBlock:^(NSNotification *note) {
        touchEnabled = YES;
    }];
    
    [PKAIDecoder builAnimatedImageInButton:self.readButton fromFile:@"lunette-picto" withColor:[UIColor blueColor]];
//    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
//    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:swipe];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (switchingView || !touchEnabled) return;
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    for (UIView *view in self.view.subviews)
    {
        if (view.tag == 60 &&
            CGRectContainsPoint(view.frame, touchLocation))
        {
            switchingView = YES;
            [self displaySelectedArticle:nil];
        }
    }
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipeRecognizer {
    [self displaySelectedArticle:swipeRecognizer];
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    
    CGRect f1 = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height);
    CGRect f2 = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    CGRect f3 = CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height);
    CGRect f4 = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
//    self.feedTableView.frame = f1;
//    self.selectedArticleCover.frame = f2;
    
//    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.feedTableView.frame = f3;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.4f  delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^() {
//            self.selectedArticleCover.frame = f4;
//        } completion:nil];
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    MainViewController* parent = (MainViewController*)self.parentViewController.parentViewController; // get the main view controller
    
    touchEnabled = YES;
    switchingView = NO;
    
    // back from article view ?
    if (parent.menuItem.frame.origin.x < 0) {
        CGRect f = self.feedTableView.frame;
        f.origin.x = - self.view.frame.size.width/2;
        self.feedTableView.frame = f;
        f = self.articleExcerpt.frame;
        f.origin.y += 200;
        self.articleExcerpt.frame = f;
        
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
            self.readButton.alpha = 1;
            f = self.articleExcerpt.frame;
            f.origin.y -= 200;
            self.articleExcerpt.frame = f;
        } completion:nil];
    }
}

- (void)loadWaitingScreen {
    UIView* screen = [[[NSBundle mainBundle] loadNibNamed:@"LoadingScreen" owner:self options:0] objectAtIndex:0];
    screen.frame = self.view.frame;
    [self.view addSubview:screen];
    
    [self.view bringSubviewToFront:screen];
    
    self.waitingScreen = screen;
}

- (void)fetchFeed {
    UserDataHolder* holder = [UserDataHolder sharedInstance];
    [holder loadData];
    
    
    [PKRestClient getFeedForUser:holder.user completion:^(id json, JSONModelError *jErr) {
        
        if(jErr != nil){
            NSLog(@"PKJError : %@", jErr.localizedDescription);
            // do we have a cached feed ?
            feedArticles = [PKCacheManager loadCachedFeed];
            
            NSLog(@"%@", feedArticles);
            
            if (feedArticles.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.feedTableView reloadData];
                    NSIndexPath* firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                    [self.feedTableView selectRowAtIndexPath:firstIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                    [self tableView:self.feedTableView didSelectRowAtIndexPath:firstIndexPath];
                    [self.waitingScreen removeFromSuperview];
                });
            } else {
                // schedule another fetch later
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self scheduleNewFetch];
                });
            }
        }else{
            //NSLog(@"Assumed DICO  : %@", json);
            
            NSError *err = nil;
            feedArticles = [Article arrayOfModelsFromDictionaries:json error:&err];
            
            if (err != nil) {
                NSLog(@"PKER : %@", err);
                
                
            } else {
                // Reload table data on main thread to avoid problems
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.feedTableView reloadData];
                    NSIndexPath* firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                    [self.feedTableView selectRowAtIndexPath:firstIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                    [self tableView:self.feedTableView didSelectRowAtIndexPath:firstIndexPath];
                    [self.waitingScreen removeFromSuperview];
                    self.feedTableView.hidden = NO;
                    [PKCacheManager cacheFeed:feedArticles];
                });
            }
        }
    }];
}

- (void)scheduleNewFetch {
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(fetchFeed) userInfo:nil repeats:NO];
}

#pragma mark - Helpers

- (NSString*)excerptOfContent:(NSString*)content firstWordsCount:(NSInteger)nWords {
    
    NSArray* components = [content componentsSeparatedByString:@" "];
    
    NSRange wordRange = NSMakeRange(0, components.count < nWords ? components.count : nWords);
    
    NSArray *firstWords = [components subarrayWithRange:wordRange];
    
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
//        self.articleExcerpt.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
        [self.articleExcerpt setFrame:f];
        f = parent.menuTopBar.frame;
        f.origin.x -= self.view.frame.size.width/2;
        [parent.menuTopBar setFrame:f];
        f = parent.menuItem.frame;
        f.origin.x -= self.view.frame.size.width/2;
        [parent.menuItem setFrame:f];
        self.readButton.alpha = 0;
    } completion:^(BOOL finished) {
        
        ArticleViewController* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ArticleViewController"];
        vc.articleCoverImage = [[UIImageView alloc] initWithFrame:self.view.frame];
        vc.articleId = selectedArticle._id;
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
    
    if(indexPath.row == 0){
        [PKAIDecoder updateAnimatedImageTintInButton:self.readButton withColor:[Utils colorWithHexString:article.color] withAnimation:YES];
    }
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FeedArticleCell"];
    }
    
    UIView* overlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width/2, self.view.frame.size.height/3)];
    overlay.tag = 5;
    overlay.backgroundColor = RgbaColor(0, 0, 0, 0.65f);
    overlay.hidden = YES;
    [cell.contentView addSubview:overlay];
    
    UILabel* feedCellTitle = (UILabel*)[cell.contentView viewWithTag:10];
    feedCellTitle.text = article.title;
    feedCellTitle.font = [UIFont fontWithName:kFontBreeBold size:15];
    feedCellTitle.textColor = kFeedViewListTitleColor;
    
    UIImageView* feedCellThumb = (UIImageView*)[cell.contentView viewWithTag:20];
//    [feedCellThumb setFrame:CGRectMake(feedCellThumb.frame.origin.x, feedCellThumb.frame.origin.y, cell.frame.size.width/3.5, cell.frame.size.height)];
    [feedCellThumb sd_setImageWithURL:[NSURL URLWithString:article.coverImage]];
    feedCellThumb.clipsToBounds = YES;
    feedCellThumb.layer.masksToBounds = YES;
    
    UILabel* themeTitle = (UILabel*)[cell.contentView viewWithTag:50];
    if (article.subthemes.count > 0)
        themeTitle.text = ((SubThemeInterest*)article.subthemes[0]).title;
    else
        themeTitle.text = @"";
    themeTitle.textColor = [Utils colorWithHexString:article.color];
    
    UIImageView* check = (UIImageView*)[cell.contentView viewWithTag:77];
    check.tintColor = [UIColor whiteColor];
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
    NSDictionary* paragraph = firstBlock.paragraphs[0];
    NSString* content = [paragraph objectForKey:@"content"];
    
    
    
    ContentParser* parser = [[ContentParser alloc] init];
        
    self.articleExcerpt.text = [self excerptOfContent:[parser getCleanedString:content] firstWordsCount:22];
    self.articleExcerpt.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    self.articleExcerpt.alpha = 0.0f;
    
    UIView* overlay = [cell.contentView viewWithTag:5];
    [cell.contentView sendSubviewToBack:overlay];
    UIView* check = [overlay viewWithTag:77];
    
    // don't allow touching again if animation not performed
    if (check.transform.a > 1.0f) {
        return;
    }
    
    check.transform = CGAffineTransformMakeScale(4.0f, 4.0f);
    check.alpha = 0;
    
    [PKAIDecoder updateAnimatedImageTintInButton:self.readButton withColor:[Utils colorWithHexString:article.color] withAnimation:YES];
    
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
    UILabel* date = (UILabel*)[cell.contentView viewWithTag:70];
    date.textColor = [UIColor whiteColor];
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
