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

@interface ArticleViewController ()

@end

@implementation ArticleViewController {
    NSMutableArray* hiddenBlocks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hiddenBlocks = [NSMutableArray array];
    
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
    
    self.parser = [[ContentParser alloc] init];
    self.parser.delegate = self;
    
    [self.collectionView registerClass:[GenericBlockCell class] forCellWithReuseIdentifier:@"GenericBlockCell"];
}

- (void)viewDidLayoutSubviews {
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 2000.0f)];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.displayedArticle.blocks count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == 0) {
        return [self articleTitleCell];
    }
    
    Block* block = [self blockAtIndexPath:indexPath];
    GenericBlockCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GenericBlockCell" forIndexPath:indexPath];
    
    [cell layoutWithBlock:block];
    
    if (block.content != nil) {
        [self.parser parseCallsFromString:block.content];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Block* block = [self blockAtIndexPath:indexPath];
    
    if ([hiddenBlocks indexOfObject:block] != NSNotFound) {
        return CGSizeMake(self.collectionView.frame.size.width, 0.0f);
    }
    
    return CGSizeMake(self.collectionView.frame.size.width, 250.0f);
}

- (UICollectionViewCell*) articleTitleCell {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ArticleTitleCell" forIndexPath:0];
    UILabel* articleTitle = (UILabel*)[cell.contentView viewWithTag:10];
    articleTitle.text = self.displayedArticle.title;
    UIImageView* imageView = (UIImageView*)[cell.contentView viewWithTag:20];
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.displayedArticle.coverImage]]];
    
    return cell;
}

- (Block*)blockAtIndexPath:(NSIndexPath*)indexPath {
    if ([indexPath row] == 0) {
        return nil;
    }
    return [self.displayedArticle.blocks objectAtIndex:[indexPath row]-1];
}

- (void)revealBlock:(UIButton*)sender {
    
    NSString* blockId = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    Block* block = nil;
    for (Block* b in self.displayedArticle.blocks) {
        if ([b.id isEqualToString:blockId]) {
            block = b;
        }
    }
    
    if (block == nil) {
        return;
    }

//    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView performBatchUpdates:^{
        [hiddenBlocks removeObject:block];
    } completion:^(BOOL finished) {
        
    }];
    
    CGPoint anchor;
    anchor.x = 0.0f; anchor.y = 400.0f;
    
    [self.collectionView setContentOffset:anchor animated:YES];
}

#pragma mark - ContentParserDelegate

- (void)parser:(ContentParser *)parser didCallBlockWithId:(NSString *)blockId atTextLocation:(NSUInteger)location {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    button.frame = CGRectMake(self.collectionView.frame.size.width-35.0f, [blockId intValue]*100.0f, 20.0f, 20.0f);
    button.tag = [blockId intValue];
    
    [button addTarget:self action:@selector(revealBlock:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.collectionView addSubview:button];
}

@end
