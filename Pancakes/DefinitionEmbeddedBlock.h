//
//  DefinitionEmbeddedBlock.h
//  Pancakes
//
//  Created by Leo on 02/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Block.h"
#import "Article.h"

@interface DefinitionEmbeddedBlock : UIView

@property (strong, nonatomic) Block* block;
@property (weak, nonatomic) Article* article;
@property (strong, nonatomic) UIView* storyline;
@property (strong, nonatomic) NSIndexPath* cellIndexPath;
@property (assign, nonatomic) BOOL layouted;

- (void)layoutWithBlock:(Block*)block offsetY:(CGFloat)offsetY;
- (void)willClose;

@end
