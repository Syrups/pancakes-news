//
//  DataEmbeddedBlock.m
//  Pancakes
//
//  Created by Leo on 14/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "DataEmbeddedBlock.h"
#import "Block.h"

@implementation DataEmbeddedBlock

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    UILabel* label = [[UILabel alloc] initWithFrame:self.frame];
    label.text = @"Data block";
    [self addSubview:label];
}

@end
