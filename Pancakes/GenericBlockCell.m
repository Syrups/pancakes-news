//
//  GenericBlockCell.m
//  Pancakes
//
//  Created by Leo on 19/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "GenericBlockCell.h"

@implementation GenericBlockCell {
    BOOL layouted;
}

@synthesize textLabel;

- (id)initWithFrame:(CGRect)frame {
    
    layouted = false;
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[GenericBlockCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
    }
    
    return self;
    
}

- (void)layoutWithBlock:(Block *)block {
    if (layouted) {
        return;
    }
    
    self.block = block;
    
    ContentParser* parser = [[ContentParser alloc] init];
    
    self.textLabel.text = block.content != nil ? [parser getCleanedString:block.content] : @"NO CONTENT";
    
    layouted = true;
}

- (void)parser:(ContentParser *)parser didCallBlockWithId:(NSString *)blockId atTextLocation:(NSUInteger)location {
    NSLog(@"%@", blockId);
}

@end
