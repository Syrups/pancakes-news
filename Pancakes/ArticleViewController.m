//
//  ArticleViewController.m
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "Macros.h"
#import "Configuration.h"
#import "ArticleViewController.h"
#import "JSONHTTPClient.h"
#import "Block.h"
#import "Blocks.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImageManager.h>
#import "PKRestClient.h"
#import "PKCacheManager.h"

typedef enum  {
    Displayed,
    Hidden
} BackButtonState;

@implementation ArticleViewController {
    NSMutableArray* hiddenBlocks;
    //UIImage *coverOriginalImage;
    //UIImage *coverBlurredImage;
    BOOL titleCellAnimated;
    BackButtonState backButtonState;
    CGFloat lastContentOffset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hiddenBlocks = [NSMutableArray array];
    
    titleCellAnimated = NO;
    
    [self fetchArticleData];
//    [self loadMenuView];
    
    self.parser = [[ContentParser alloc] init];
    self.parser.delegate = self;
    
    self.articleCoverImage.image = self.cover;
    self.articleCoverImage.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    
    self.scrollListeners = @[].mutableCopy;
    
    [self.collectionView registerClass:[GenericBlockCell class] forCellWithReuseIdentifier:@"GenericBlockCell"];
    [self.collectionView registerClass:[SectionBlockCell class] forCellWithReuseIdentifier:@"SectionBlockCell"];
    [self.collectionView registerClass:[EditorsBlockCell class] forCellWithReuseIdentifier:@"EditorsBlockCell"];
    [self.collectionView registerClass:[CommentsBlockCell class] forCellWithReuseIdentifier:@"CommentsBlockCell"];
    
    
    UISwipeGestureRecognizer *swipeBack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    [swipeBack setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:swipeBack];
    
//    UISwipeGestureRecognizer *swipeMenu = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(displayMenu:)];
//    [swipeMenu setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [[self view] addGestureRecognizer:swipeMenu];
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    self.effectView = visualEffectView;
    visualEffectView.frame = self.view.bounds;
    [self.articleCoverImage addSubview:visualEffectView];
    self.effectView.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    for (int i = 0; i < self.displayedArticle.blocks.count ; i++) {
        [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    }
}

- (void)fetchArticleData {
    // TEST
//    self.displayedArticle = [[Article alloc] init];
//    self.displayedArticle._id = @"5440d1b7cd53de6649187c8b";
    // /TEST
    
    //NSString* articlePath = [NSString stringWithFormat:@"/articles/%@", self.displayedArticle._id];
    //NSString* articleUrl = [PKRestClient apiUrlWithRoute:articlePath];
    
   [PKRestClient getArticleWithId:self.articleId :^(id json, JSONModelError *err) {
        NSError* error = nil;
       
       if (err) { // error connecting to network, try loading from cache
           NSArray* cachedFeed = [PKCacheManager loadCachedFeed];
           for (Article* a in cachedFeed) {
               if ([a._id isEqualToString:self.displayedArticle._id]) {
                   self.displayedArticle = a;
               }
           }
       } else {
           self.displayedArticle = [[Article alloc] initWithDictionary:json error:&error];
       }
    
       
        self.articleTitleLabel.text = self.displayedArticle.title;
        
        for (Block* block in self.displayedArticle.blocks) {
            if (![block.type.name isEqualToString:@"generic"]) {
                [hiddenBlocks addObject:block];
            }
            if ([block.type.name isEqualToString:@"context"]) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:block.image] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    
                }];
            }
        }
        
        //coverOriginalImage = self.articleCoverImage.image;
       if (self.displayedArticle != nil) {
           [PKCacheManager saveLastReadArticle:self.displayedArticle];
       }
        [self.collectionView reloadData];
       
        [self createMainMenu];
        [self createDetailMenu];
    }];
    
    
}

- (Block*)blockAtIndexPath:(NSIndexPath*)indexPath {
    if ([indexPath row] == 0) {
        return nil;
    }

    return [self.displayedArticle.blocks objectAtIndex:[indexPath row]-1];
}

#pragma mark - Menu

- (void) createMainMenu {
    
    float screenMidSize =self.view.frame.size.width/2;
    
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleMenuView"];
    [self addChildViewController:self.menuViewController];
    self.menuViewController.view.frame = CGRectMake(self.view.frame.size.width, 0.0f, screenMidSize, self.view.frame.size.height);
    self.menuViewController.article = self.displayedArticle;
    
    [self.view addSubview:self.menuViewController.view];
    [self.menuViewController didMoveToParentViewController:self];

}

- (void) createDetailMenu {
    
    float screenMidSize =self.view.frame.size.width/2;
    
    self.menuDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleMenuDetailView"];
    [self addChildViewController:self.menuDetailViewController];
    self.menuDetailViewController.view.frame = CGRectMake(0.0f, self.view.frame.size.height, screenMidSize, self.view.frame.size.height);
    
    [self.view addSubview:self.menuDetailViewController.view];
    [self.menuDetailViewController didMoveToParentViewController:self];
}

#pragma mark - Actions

- (IBAction)back:(id)sender {
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.collectionView setFrame:CGRectMake(self.view.frame.size.width, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height)];
        CGRect f = self.moreButtonBackground.frame;
        f.origin.x = self.view.frame.size.width + 100;
        self.moreButtonBackground.frame = f;
        f = self.moreButton.frame;
        f.origin.x = self.view.frame.size.width + 100;
        self.moreButton.frame = f;
        
        f = self.backButton.frame;
        f.origin.y = -100;
        self.backButton.frame = f;
        
        self.effectView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

- (IBAction)displayMenu:(id)sender {
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.menuViewController.view setFrame:CGRectMake(self.view.frame.size.width/2, 0.0f, self.view.frame.size.width/2, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.menuDetailViewController.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width/2, self.view.frame.size.height)];
    } completion:nil];

}

#pragma mark - Swipe to zoom on cover

- (void)zoomCover:(UIGestureRecognizer*)swipe {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ArticleTitleCell" forIndexPath:0];
    UILabel* articleTitle = (UILabel*)[cell.contentView viewWithTag:10];
    articleTitle.text = self.displayedArticle.title;
    UILabel* creditsLabel = (UILabel*)[cell.contentView viewWithTag:20];
    creditsLabel.text = self.displayedArticle.credits;
    
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        articleTitle.alpha = 0;
        creditsLabel.alpha = 0;
    } completion:nil];
}

#pragma mark - Helpers

/**
 * Build the article title cell at the top of the view
 */

- (UICollectionViewCell*) articleTitleCell {
    
    
    
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ArticleTitleCell" forIndexPath:0];
    
    if (self.displayedArticle == nil) return cell;
    UILabel* articleTitle = (UILabel*)[cell.contentView viewWithTag:10];
    articleTitle.text = self.displayedArticle.title;
    articleTitle.textColor = [UIColor whiteColor];
    articleTitle.font = [UIFont fontWithName:kFontBreeBold size:32];
    
    UILabel* creditsLabel = (UILabel*)[cell.contentView viewWithTag:20];
    creditsLabel.text = self.displayedArticle.credits;
    creditsLabel.textColor = [UIColor whiteColor];
    creditsLabel.font = [UIFont fontWithName:kFontHeuristicaItalic size:18];
    
    UISwipeGestureRecognizer* swipeToZoom = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(zoomCover:)];
    swipeToZoom.direction = UISwipeGestureRecognizerDirectionDown;
//    [cell.contentView addGestureRecognizer:swipeToZoom];
    
    if (!titleCellAnimated) {
        
        CGRect f = self.moreButtonBackground.frame;
        f.origin.y = -60.0f;
        self.moreButtonBackground.frame = f;
        f = self.moreButton.frame;
        f.origin.y = -50.0f;
        self.moreButton.frame = f;
        
        [UIView animateWithDuration:0.6f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect f = self.moreButtonBackground.frame;
            f.origin.y = 15.0f;
            self.moreButtonBackground.frame = f;
            self.moreButtonBackground.alpha = 1.0f;
            self.moreButtonBackground.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:NULL];
        
        [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect f = self.moreButton.frame;
            f.origin.y = 15.0f;
            self.moreButton.frame = f;
            self.moreButton.alpha = 1.0f;
        } completion:NULL];
        
        [UIView animateWithDuration:0.6f delay:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = articleTitle.frame;
            frame.origin.y += self.view.frame.size.height;
            articleTitle.frame = frame;
            [articleTitle setAlpha:1.0f];
            frame = creditsLabel.frame;
            frame.origin.y += self.view.frame.size.height;
            creditsLabel.frame = frame;
            [creditsLabel setAlpha:1.0f];
            
            UIView *storyline = [[UIView alloc] initWithFrame:CGRectMake(self.moreButtonBackground.frame.origin.x + self.moreButtonBackground.frame.size.width/2, self.moreButtonBackground.frame.origin.y + self.moreButtonBackground.frame.size.height+15.0f, 1.0f, 0.0f)];
            storyline.backgroundColor = RgbColor(180, 180, 180);
            [cell addSubview:storyline];
            
            frame = storyline.frame;
            frame.size.height = self.view.frame.size.height * 1.75f
            ;
            storyline.frame = frame;
            
        } completion:^(BOOL finished) {
            titleCellAnimated = YES;
            NSLog(@"TITLE : %f", articleTitle.frame.origin.y);
            
        }];
    }
    
    return cell;
}


- (Block*) blockWithId:(NSString*)blockId {
    Block* block = nil;
    for (Block* b in self.displayedArticle.blocks) {
        if ([b.id isEqualToString:blockId]) {
            block = b;
        }
    }
    
    return block;
}

- (CGSize) sizeForBlock:(Block*)block {
    CGFloat w = self.collectionView.frame.size.width;
    
    // If hidden block height is 0
    if ([hiddenBlocks indexOfObject:block] != NSNotFound) {
        return CGSizeMake(w, 60.0f);
    }
    
    if ([block.type.name isEqualToString:@"context"]) {
        return CGSizeMake(w, block.paragraphs.count * 300 + 250.0f);
    } else if ([block.type.name isEqualToString:@"editors"]) {
        return CGSizeMake(w, block.editors.count * 450);
    } else if ([block.type.name isEqualToString:@"comments"]) {
        return CGSizeMake(w, 300 + self.displayedArticle.comments.count * 200.0f);
    }
    
    // generic block of content
    return CGSizeMake(w, block.paragraphs.count * 100 + block.children.count  * 300);
}


/*- (UICollectionViewCell*) articleTitleCell {
    
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ArticleTitleCell" forIndexPath:0];
    UILabel* articleTitle = (UILabel*)[cell.contentView viewWithTag:10];
    articleTitle.text = self.displayedArticle.title;
    articleTitle.textColor = [UIColor whiteColor];
    articleTitle.font = [UIFont fontWithName:kFontBreeBold size:32];
    
    UILabel* creditsLabel = (UILabel*)[cell.contentView viewWithTag:20];
    creditsLabel.text = self.displayedArticle.credits;
    creditsLabel.textColor = [UIColor whiteColor];
    creditsLabel.font = [UIFont fontWithName:kFontHeuristicaItalic size:18];
    
    if (!titleCellAnimated) {
        CGRect f = self.moreButtonBackground.frame;
        f.origin.y = -60.0f;
        self.moreButtonBackground.frame = f;
        f = self.moreButton.frame;
        f.origin.y = -50.0f;
        self.moreButton.frame = f;
        
        [UIView animateWithDuration:0.6f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect f = self.moreButtonBackground.frame;
            f.origin.y = 15.0f;
            self.moreButtonBackground.frame = f;
            self.moreButtonBackground.alpha = 1.0f;
            self.moreButtonBackground.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:NULL];
        
        [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect f = self.moreButton.frame;
            f.origin.y = 15.0f;
            self.moreButton.frame = f;
            self.moreButton.alpha = 1.0f;
        } completion:NULL];
        
        [UIView animateWithDuration:0.6f delay:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = articleTitle.frame;
            frame.origin.y += self.view.frame.size.height;
            articleTitle.frame = frame;
            [articleTitle setAlpha:1.0f];
            frame = creditsLabel.frame;
            frame.origin.y += self.view.frame.size.height;
            creditsLabel.frame = frame;
            [creditsLabel setAlpha:1.0f];
            
            UIView *storyline = [[UIView alloc] initWithFrame:CGRectMake(self.moreButtonBackground.frame.origin.x + self.moreButtonBackground.frame.size.width/2, self.moreButtonBackground.frame.origin.y + self.moreButtonBackground.frame.size.height, 1.0f, 0.0f)];
            storyline.backgroundColor = RgbColor(180, 180, 180);
            [cell addSubview:storyline];
            
            frame = storyline.frame;
            frame.size.height = self.view.frame.size.height * 1.75f
            ;
            storyline.frame = frame;
        } completion:^(BOOL finished) {
            titleCellAnimated = YES;
        }];
    }
    
    return cell;
}*/

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.displayedArticle.blocks count] + 1;
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == 0) {
        return [self articleTitleCell];
    }
    
    Block* block = [self blockAtIndexPath:indexPath];
    GenericBlockCell* cell = nil;
    
    if (![block.type.name isEqualToString:@"generic"]) {
        if ([block.type.name isEqualToString:@"editors"]) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EditorsBlockCell" forIndexPath:indexPath];
        } else if ([block.type.name isEqualToString:@"comments"]) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommentsBlockCell" forIndexPath:indexPath];
        } else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SectionBlockCell" forIndexPath:indexPath];
        }
        cell.contentView.alpha = 0.0f;
        cell.articleViewController = self;
        [cell layoutWithBlock:block offsetY:40.0f];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GenericBlockCell" forIndexPath:indexPath];
        cell.articleViewController = self;
        [cell loadWithBlock:block];
        
    }
    
//    NSLog(@"Showing block cell with block index %lu and ID %@ and type %@ for indexPath row %ld", (unsigned long) [self.displayedArticle.blocks indexOfObject:block], block.id, block.type.name, (long)indexPath.row);
//    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == 0) {
        return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height * 1.75);
    }
    
    Block* block = [self blockAtIndexPath:indexPath];
    
    return [self sizeForBlock:block];
}

- (void)revealBlockAtIndexPath:(NSIndexPath *)indexPath {
    Block* block = [self blockAtIndexPath:indexPath];
    
    if ([hiddenBlocks indexOfObject:block] == NSNotFound) {
        return;
    }
    
    SectionBlockCell* cell = (SectionBlockCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self.scrollListeners addObject:cell];
    //        [self.collectionView.collectionViewLayout invalidateLayout];

    [self.collectionView performBatchUpdates:^{
        
        [hiddenBlocks removeObject:block];
        [cell openWithAnimation];
        [self.collectionView setContentOffset:CGPointMake(0.0f, cell.frame.origin.y - 1) animated:YES];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closeBlockAtIndexPath:(NSIndexPath *)indexPath {
    Block* block = [self blockAtIndexPath:indexPath];
    
    if ([hiddenBlocks indexOfObject:block] != NSNotFound) {
        return;
    }
    
    SectionBlockCell* cell = (SectionBlockCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    //        [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView performBatchUpdates:^{
        
        [hiddenBlocks addObject:block];
        [cell closeWithAnimation];
        [self.collectionView setContentOffset:CGPointMake(0.0f, cell.frame.origin.y - self.view.bounds.size.height/2 + 30) animated:YES];
        
    } completion:^(BOOL finished) {
        [cell layoutWithBlock:cell.block offsetY:0.0f];
    }];
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    Block* block = [self blockAtIndexPath:indexPath];
//    SectionBlockCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//    
//    if (block == nil || [cell class] != [SectionBlockCell class]) return;
//    
//    //    [self.collectionView.collectionViewLayout invalidateLayout];
//    [self.collectionView performBatchUpdates:^{
//        if ([hiddenBlocks indexOfObject:block] == NSNotFound) {
//            [hiddenBlocks addObject:block];
//            [cell closeWithAnimation];
//        }
//    } completion:^(BOOL finished) {
//        
//    }];
//}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (scrollView.contentOffset.y >= 120.0f && scrollView.contentOffset.y < self.view.frame.size.height + self.view.frame.size.height/2) {
        
        [self.collectionView setContentOffset:CGPointMake(0.0f, self.view.frame.size.height*1.32) animated:YES];
        
        if (backButtonState == Displayed) {
            [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect f = self.backButton.frame;
                f.origin.y -= 50.0f;
                self.backButton.frame = f;
            } completion:nil];
            backButtonState = Hidden;
        }
        
        }
    if (scrollView.contentOffset.y <= 100.0f) {
        [self.collectionView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scroll.end" object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    for (GenericBlockCell* listener in self.scrollListeners) {
        [listener scrollViewDidScroll:scrollView];
    }
    
    if (scrollView.contentOffset.y < lastContentOffset && backButtonState == Hidden) {
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect f = self.backButton.frame;
            f.origin.y += 50.0f;
            self.backButton.frame = f;
        } completion:nil];
        backButtonState = Displayed;
    }

    
    lastContentOffset = scrollView.contentOffset.y;
    
    self.effectView.alpha = self.collectionView.contentOffset.y / 200;
    
    if (self.collectionView.contentOffset.y > self.articleCoverImage.frame.size.height/2 || self.collectionView.contentOffset.y <= 0) return;
    
    if (self.collectionView.contentOffset.y == 0) {
        self.effectView.alpha = 0;
    } else {
//        self.coverBlur.alpha = 1;
//        int radius = self.collectionView.contentOffset.y / 7;
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            
//            //coverBlurredImage = [coverOriginalImage stackBlur:radius];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                //[self.articleCoverImage setImage:coverBlurredImage];
//            });
//        });
        
        self.effectView.alpha = self.collectionView.contentOffset.y / 200;
    }
    
    
}



@end
