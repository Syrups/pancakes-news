//
//  GenericBlockCell.h
//  Pancakes
//
//  Created by Leo on 19/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Block.h"
#import "ContentParser.h"
#import "ArticleViewController.h"

@interface GenericBlockCell : UICollectionViewCell <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Block* block;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ArticleViewController* articleViewController;

- (void)loadWithBlock:(Block*)block;
- (void)layoutWithBlock:(Block*)block offsetY:(CGFloat)offsetY;
- (void)openEmbeddedBlockWithId:(NSString*)blockId completion:(void(^)())completion;

@end
