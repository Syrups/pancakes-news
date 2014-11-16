//
//  CommentsBlockCell.m
//  Pancakes
//
//  Created by Leo on 15/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "CommentsBlockCell.h"

@implementation CommentsBlockCell

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    if (self.opened) return;
    
    [super layoutWithBlock:block offsetY:offsetY];
}

@end
