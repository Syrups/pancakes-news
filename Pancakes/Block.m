//
//  Block.m
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "Block.h"

@implementation Block

- (Block *)childWithId:(NSString *)blockId {
    for (Block* block in self.children) {
        if ([block.id isEqualToString:blockId]) {
            return block;
        }
    }
    
    return nil;
}

@end
