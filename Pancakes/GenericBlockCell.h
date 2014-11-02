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

@interface GenericBlockCell : UICollectionViewCell

@property (strong, nonatomic) Block* block;
@property (strong, nonatomic) UILabel *textLabel;

- (void)layoutWithBlock:(Block*)block offsetY:(CGFloat)offsetY;
- (void)openEmbeddedBlockWithId:(NSString*)blockId completion:(void(^)())completion;

@end
