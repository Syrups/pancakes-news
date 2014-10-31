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
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+StackBlur.h"

@interface ArticleViewController ()

@end

@implementation ArticleViewController {
    NSMutableArray* hiddenBlocks;
    UIImage *coverOriginalImage;
    UIImage *coverBlurredImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hiddenBlocks = [NSMutableArray array];
    
    [self fetchArticleData];
    [self loadMenuView];
    
    self.parser = [[ContentParser alloc] init];
    self.parser.delegate = self;
    
    [self.collectionView registerClass:[GenericBlockCell class] forCellWithReuseIdentifier:@"GenericBlockCell"];
}

- (void)viewDidLayoutSubviews {
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 2000.0f)];
}

- (void)fetchArticleData {
    // TEST
    self.displayedArticle = [[Article alloc] init];
    self.displayedArticle._id = @"5440d1b7cd53de6649187c8b";
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
       
        [self.articleCoverImage sd_setImageWithURL:[NSURL URLWithString:self.displayedArticle.coverImage] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image != nil) {
                    coverOriginalImage = self.articleCoverImage.image;
                }
        }];
        
        
        [self.collectionView reloadData];
    }];

}

- (Block*)blockAtIndexPath:(NSIndexPath*)indexPath {
    if ([indexPath row] == 0) {
        return nil;
    }

    return [self.displayedArticle.blocks objectAtIndex:[indexPath row]-1];
}

#pragma mark - Helper view methods

/**
 * Build the article title cell at the top of the view
 */

- (UICollectionViewCell*) articleTitleCell {
    
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ArticleTitleCell" forIndexPath:0];
    UILabel* articleTitle = (UILabel*)[cell.contentView viewWithTag:10];
    articleTitle.text = self.displayedArticle.title;

    articleTitle.textColor = [UIColor whiteColor];
    articleTitle.font = [UIFont fontWithName:kFontBreeBold size:36];
    
    return cell;
}

- (IBAction)toggleMenu:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    
    CGRect rightFrame = self.rightMenuView.frame;
    CGRect leftFrame = self.leftMenuView.frame;
    
    CGFloat screenSize = self.view.frame.size.width;
    
    if (leftFrame.origin.x == 0) { // if menu displayed
        rightFrame.origin.x = screenSize;
        leftFrame.origin.x = -screenSize/2;
    } else {
        rightFrame.origin.x = screenSize/2;
        leftFrame.origin.x = 0.0f;
    }
    
    self.rightMenuView.frame = rightFrame;
    self.leftMenuView.frame = leftFrame;
    
    [UIView commitAnimations];
}

- (void)loadMenuView {
    CGRect rightFrame = self.view.frame;
    CGRect leftFrame = self.view.frame;
    CGFloat screenSize = self.view.frame.size.width;
    rightFrame.origin.x = screenSize;
    leftFrame.origin.x = - screenSize/2;
    rightFrame.size.width /= 2; leftFrame.size.width /= 2;
    
    self.rightMenuView = [[[UINib nibWithNibName:@"ArticleRightMenu" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.rightMenuView.frame = rightFrame;
    self.rightMenuView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    self.leftMenuView = [[[UINib nibWithNibName:@"ArticleLeftMenu" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.leftMenuView.frame = leftFrame;
    self.leftMenuView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    
    [self.view addSubview:self.rightMenuView];
    [self.view addSubview:self.leftMenuView];
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
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GenericBlockCell" forIndexPath:indexPath];
    
    if (![block.type.name isEqualToString:@"generic"]) {
        cell.backgroundColor = [UIColor orangeColor];
    } else {
        cell.backgroundColor = kArticleViewBlockBackground;
    }
    
    [cell layoutWithBlock:block];
    
    NSLog(@"Showing block cell with block index %lu and ID %@ and type %@ for indexPath row %ld", (unsigned long) [self.displayedArticle.blocks indexOfObject:block], block.id, block.type.name, indexPath.row);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == 0) {
        return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height * 1.5);
    }
    
    Block* block = [self blockAtIndexPath:indexPath];
    
    if ([hiddenBlocks indexOfObject:block] != NSNotFound) {
        return CGSizeMake(self.collectionView.frame.size.width, 50.0f);
    }
    
    return CGSizeMake(
                self.collectionView.frame.size.width,
                [block.paragraphs count] * 150.0f // This is dirty, we'll do something cleverer later :)
            );
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Block* block = [self blockAtIndexPath:indexPath];
    
    if ([hiddenBlocks indexOfObject:block] == NSNotFound) {
        return;
    }
    
    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    //        [self.collectionView.collectionViewLayout invalidateLayout];
    NSLog(@"%f", cell.frame.origin.y);
    [self.collectionView performBatchUpdates:^{
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self.collectionView setContentOffset:CGPointMake(0, cell.frame.origin.y)];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y - 20.0f)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.12f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y + 20.0f)];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.08f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                        [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y - 8.0f)];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.08f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                            [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y + 8.0f)];
                        } completion:NULL];
                    }];
                }];
            }];
        }];
        
        
        [hiddenBlocks removeObject:block];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    Block* block = [self blockAtIndexPath:indexPath];
    
    if (block == nil) return;
    
    //    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView performBatchUpdates:^{
        if ([hiddenBlocks indexOfObject:block] == NSNotFound) {
            [hiddenBlocks addObject:block];
        }
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - ContentParserDelegate

- (void)parser:(ContentParser *)parser didCallBlockWithId:(NSString *)blockId atTextLocation:(NSUInteger)location {
//    Block* calledBlock = [self blockWithId:blockId];
//    
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeInfoLight];
//    button.frame = CGRectMake(self.collectionView.frame.size.width-35.0f, [blockId intValue]*100.0f, 20.0f, 20.0f);
//    button.tag = [blockId intValue];
//    
//    [button addTarget:self action:@selector(revealBlock:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.collectionView addSubview:button];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"%f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y >= 150.0f && scrollView.contentOffset.y < self.view.frame.size.height + self.view.frame.size.height/2) {
        
        [self.collectionView setContentOffset:CGPointMake(0.0f, self.view.frame.size.height) animated:YES];
    }
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    NSLog(@"%ld", (unsigned long) scrollView.contentOffset.y);

    if (self.collectionView.contentOffset.y > self.articleCoverImage.frame.size.height/2 || self.collectionView.contentOffset.y <= 0) return;
    
    if (self.collectionView.contentOffset.y == 0) {
        [self.articleCoverImage setImage:coverOriginalImage];
    } else {
        int radius = self.collectionView.contentOffset.y / 5;
//        coverBlurredImage = [coverOriginalImage stackBlur:radius];
//        [self.articleCoverImage setImage:coverBlurredImage];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            coverBlurredImage = [coverOriginalImage stackBlur:radius];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.articleCoverImage setImage:coverBlurredImage];
            });
        });
    }
}


@end
