//
//  DefinitionEmbeddedBlock.h
//  Pancakes
//
//  Created by Leo on 02/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Block.h"

@interface DefinitionEmbeddedBlock : UIView

- (void)layoutWithBlock:(Block*)block offsetY:(CGFloat)offsetY;

@end
