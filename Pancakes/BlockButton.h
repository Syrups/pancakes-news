//
//  BlockButton.h
//  Pancakes
//
//  Created by Leo on 25/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockType.h"

@interface BlockButton : UIButton

@property (strong, nonatomic) BlockType* type;
@property (strong, nonatomic) UIColor* color;

- (instancetype) initWithFrame:(CGRect)frame blockType:(BlockType*)type color:(UIColor*)color;

@end
