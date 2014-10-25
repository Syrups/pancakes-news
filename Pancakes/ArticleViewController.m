//
//  ArticleViewController.m
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ArticleViewController.h"
#import "JSONHTTPClient.h"
#import "Block.h"
#import "GenericBlockCell.h"
#import "MapBlockCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>

@interface ArticleViewController ()

@end

@implementation ArticleViewController {
    NSMutableArray* hiddenBlocks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hiddenBlocks = [NSMutableArray array];
    
    [self fetchArticleData];
    [self loadMenuView];
    
    self.parser = [[ContentParser alloc] init];
    self.parser.delegate = self;
    
    [self.collectionView registerClass:[GenericBlockCell class] forCellWithReuseIdentifier:@"GenericBlockCell"];
    [self.collectionView registerClass:[MapBlockCell class] forCellWithReuseIdentifier:@"MapBlockCell"];
}

- (void)viewDidLayoutSubviews {
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 2000.0f)];
}

- (void)fetchArticleData {
    // TEST
    self.displayedArticle = [[Article alloc] init];
    self.displayedArticle._id = @"5440d1b7cd53de6649187c8b";
    // /TEST
    
    NSString* articleUrl = [NSString stringWithFormat:@"http://localhost:5000/api/articles/%@", self.displayedArticle._id];
    
    [JSONHTTPClient getJSONFromURLWithString:articleUrl completion:^(NSDictionary *json, JSONModelError *err) {
        NSError* error = nil;
        self.displayedArticle = [[Article alloc] initWithDictionary:json error:&error];
        self.articleTitleLabel.text = self.displayedArticle.title;
        
        for (Block* block in self.displayedArticle.blocks) {
            if (![block.type.name isEqualToString:@"generic"]) {
                [hiddenBlocks addObject:block];
            }
        }
        
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
    
    articleTitle.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    UIImageView* imageView = (UIImageView*)[cell.contentView viewWithTag:20];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.displayedArticle.coverImage] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image != nil) {
            [imageView setImageToBlur:image blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:^{
            }];
        }
    }];
    
    articleTitle.frame = imageView.frame;
    articleTitle.textColor = [UIColor whiteColor];
    
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

/**
 * Reveals a hidden block and scroll to it
 */

- (void)revealBlock:(UIButton*)sender {
    
    NSString* blockId = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    Block* block = [self blockWithId:blockId];
    
    NSUInteger index = [self.displayedArticle.blocks indexOfObject:block];
    UICollectionViewCell* cell = [self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index+1 inSection:0]];
    
    //    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView performBatchUpdates:^{
        [hiddenBlocks removeObject:block];
    } completion:^(BOOL finished) {
        // scroll to revealed block
        CGPoint anchor;
        anchor.x = 0.0f; anchor.y = cell.frame.origin.y;
        
        [self.collectionView setContentOffset:anchor animated:YES];
    }];
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
    
    if ([block.type.name isEqualToString:@"map"]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MapBlockCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GenericBlockCell" forIndexPath:indexPath];
    }
    
    [cell layoutWithBlock:block];
    
    if (block.content != nil) {
        [self.parser parseCallsFromString:block.content];
    }
    
    NSLog(@"Showing block cell with block index %lu", (unsigned long) [self.displayedArticle.blocks indexOfObject:block]);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == 0) {
        return CGSizeMake(self.collectionView.frame.size.width, 250.0f);
    }
    
    Block* block = [self blockAtIndexPath:indexPath];
    
    if ([hiddenBlocks indexOfObject:block] != NSNotFound) {
        return CGSizeMake(self.collectionView.frame.size.width, 0.0f);
    }
    
//    return CGSizeMake(
//                self.collectionView.frame.size.width,
//                [block.content sizeWithFont:[UIFont fontWithName:@"Arial" size:20.0f] constrainedToSize:CGSizeMake(self.collectionView.frame.size.width, 9999.0f) lineBreakMode: NSLineBreakByWordWrapping].height
//            );
    
    return CGSizeMake(
                self.collectionView.frame.size.width,
                250.0f
            );
}

#pragma mark - ContentParserDelegate

- (void)parser:(ContentParser *)parser didCallBlockWithId:(NSString *)blockId atTextLocation:(NSUInteger)location {
    Block* calledBlock = [self blockWithId:blockId];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    button.frame = CGRectMake(self.collectionView.frame.size.width-35.0f, [blockId intValue]*100.0f, 20.0f, 20.0f);
    button.tag = [blockId intValue];
    
    [button addTarget:self action:@selector(revealBlock:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.collectionView addSubview:button];
}

@end
