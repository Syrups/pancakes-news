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

@interface GenericBlockCell : UICollectionViewCell <ContentParserDelegate>

@property (strong, nonatomic) Block* block;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (void)layoutWithBlock:(Block*)block;

@end
