//
//  SectionBlockCell.h
//  Pancakes
//
//  Created by Leo on 31/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericBlockCell.h"

@interface SectionBlockCell : GenericBlockCell

@property (assign, nonatomic) BOOL opened;

@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UIView* titleBanner;
@property (strong, nonatomic) UIImageView *coverImage;
@property (strong, nonatomic) UIView* imageMask;

- (void)layoutWithBlock:(Block*)block offsetY:(CGFloat)offsetY;
- (void) openWithAnimation;
- (void) closeWithAnimation;

@end
