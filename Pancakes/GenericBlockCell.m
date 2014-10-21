//
//  GenericBlockCell.m
//  Pancakes
//
//  Created by Leo on 19/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "GenericBlockCell.h"

@implementation GenericBlockCell

@synthesize textLabel;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        CGRect frame = self.contentView.frame;
        frame.size.width = 480.0f;
        self.textLabel = [[UILabel alloc] initWithFrame:frame];
        
        [self.contentView addSubview:self.textLabel];
        [self.layer setMasksToBounds:YES];
    }
    
    return self;
}

- (void)layoutWithBlock:(Block *)block {
    self.block = block;
    
    ContentParser* parser = [[ContentParser alloc] init];
    parser.delegate = self;
    if (block.content != nil) {
        [parser parseCallsFromString:block.content];
    }
    
    self.textLabel.text = block.content != nil ? [parser getCleanedString:block.content] : @"NO CONTENT";
}

- (void)parser:(ContentParser *)parser didCallBlockWithId:(NSString *)blockId atTextLocation:(NSUInteger)location {
    NSLog(@"%@", blockId);
}

@end
