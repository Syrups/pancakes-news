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
#import "GenericBlockCell.h"
#import "SectionBlockCell.h"
#import "EditorsBlockCell.h"
#import "CommentsBlockCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hiddenBlocks = [NSMutableArray array];
    
    titleCellAnimated = false;
    
    [self fetchArticleData];
//    [self loadMenuView];
    
    self.parser = [[ContentParser alloc] init];
    self.parser.delegate = self;
    
    //Blur radius init
    self.coverBlur.blurRadius = 0;
    self.coverBlur.dynamic = YES;
    [self.coverBlur setTintColor:[UIColor clearColor]];
    
    
    self.articleCoverImage.image = self.cover;
    self.articleCoverImage.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    
    self.scrollListeners = @[].mutableCopy;
    
    [self.collectionView registerClass:[GenericBlockCell class] forCellWithReuseIdentifier:@"GenericBlockCell"];
    [self.collectionView registerClass:[SectionBlockCell class] forCellWithReuseIdentifier:@"SectionBlockCell"];
    [self.collectionView registerClass:[EditorsBlockCell class] forCellWithReuseIdentifier:@"EditorsBlockCell"];
    [self.collectionView registerClass:[CommentsBlockCell class] forCellWithReuseIdentifier:@"CommentsBlockCell"];
    
    [self createMainMenu];
    [self createDetailMenu];
}

- (void)fetchArticleData {
    // TEST
//    self.displayedArticle = [[Article alloc] init];
//    self.displayedArticle._id = @"5440d1b7cd53de6649187c8b";
    // /TEST
    
    NSString* articlePath = [NSString stringWithFormat:@"/articles/%@", self.displayedArticle._id];
    NSString* articleUrl = [kApiRootUrl stringByAppendingString:articlePath];
    
    [JSONHTTPClient getJSONFromURLWithString:articleUrl completion:^(NSDictionary *json, JSONModelError *err) {
        NSError* error = nil;
        self.displayedArticle = [[Article alloc] initWithDictionary:json error:&error];
        self.articleTitleLabel.text = self.displayedArticle.title;
        
        for (Block* block in self.displayedArticle.blocks) {
            if (![block.type.name isEqualToString:@"generic"]) {
                [hiddenBlocks addObject:block];
            }
        }
        
        //coverOriginalImage = self.articleCoverImage.image;
        
        [self.collectionView reloadData];
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
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)displayMenu:(id)sender {
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.menuViewController.view setFrame:CGRectMake(self.view.frame.size.width/2, 0.0f, self.view.frame.size.width/2, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.menuDetailViewController.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width/2, self.view.frame.size.height)];
        } completion:nil];
    }];
}

#pragma mark - Helpers

/**
 * Build the article title cell at the top of the view
 */

- (UICollectionViewCell*) articleTitleCell {
    
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
            self.moreButtonBackground.transform = CGAffineTransformMakeRotation(M_PI );
        } completion:NULL];
        
        [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect f = self.moreButton.frame;
            f.origin.y = 30.0f;
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
        return CGSizeMake(w, 70.0f);
    }
    
    if ([block.type.name isEqualToString:@"context"]) {
        return CGSizeMake(w, block.paragraphs.count * 150 + block.children.count  * 200);
    } else if ([block.type.name isEqualToString:@"editors"]) {
        return CGSizeMake(w, block.editors.count * 450);
    } else if ([block.type.name isEqualToString:@"comments"]) {
        return CGSizeMake(w, 600);
    }
    
    // generic block of content
    return CGSizeMake(w, block.paragraphs.count * 150 + block.children.count  * 200);
}

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
    
    NSLog(@"Showing block cell with block index %lu and ID %@ and type %@ for indexPath row %ld", (unsigned long) [self.displayedArticle.blocks indexOfObject:block], block.id, block.type.name, (long)indexPath.row);
    
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
    //        [self.collectionView.collectionViewLayout invalidateLayout];
    NSLog(@"%f", cell.frame.origin.y);
    [self.collectionView performBatchUpdates:^{
        
        [hiddenBlocks removeObject:block];
        [cell openWithAnimation];
        [self.collectionView setContentOffset:CGPointMake(0.0f, cell.frame.origin.y + 8.0f) animated:YES];
        
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
        [self.collectionView setContentOffset:CGPointMake(0.0f, cell.frame.origin.y - 80.0f) animated:YES];
        
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
    NSLog(@"%f", scrollView.contentOffset.y);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    
    self.coverBlur.blurRadius = self.collectionView.contentOffset.y / 7;
    
    if (self.collectionView.contentOffset.y > self.articleCoverImage.frame.size.height/2 || self.collectionView.contentOffset.y <= 0) return;
    
    if (self.collectionView.contentOffset.y == 0) {
        //[self.articleCoverImage setImage:coverOriginalImage];
    } else {
        int radius = self.collectionView.contentOffset.y / 7;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            //coverBlurredImage = [coverOriginalImage stackBlur:radius];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //[self.articleCoverImage setImage:coverBlurredImage];
            });
        });
    }
    
    
    
    if (scrollView.contentOffset.y <= 150.0f) {
        if (backButtonState == Hidden) {
            [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect f = self.backButton.frame;
                f.origin.y += 50.0f;
                self.backButton.frame = f;
            } completion:nil];
            backButtonState = Displayed;
        }
    }
    
    for (GenericBlockCell* listener in self.scrollListeners) {
        NSLog(@"SCROOOL");
            [listener scrollViewDidScroll:scrollView];
        
    }
}


@end
