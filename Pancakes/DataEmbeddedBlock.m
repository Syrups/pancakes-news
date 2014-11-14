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
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100.0f)];
    label.text = @"Data block";
    [self addSubview:label];
    
}

@end
