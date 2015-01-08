//
//  SectionBlockCell.h
//  Pancakes
//
//  Created by Leo on 31/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericBlockCell.h"
#import "ArcImageView.h"

@interface SectionBlockCell : GenericBlockCell

@property (assign, nonatomic) BOOL opened;
@property (assign, nonatomic) BOOL blurEnabled;

@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UIView* titleBanner;
@property (strong, nonatomic) ArcImageView *coverImage;
@property (strong, nonatomic) UIView* imageMask;
@property (strong, nonatomic) UIImageView* blurImage;
@property (strong, nonatomic) UIButton* revealButton;
@property (strong, nonatomic) UIButton* closeButton;
@property (strong, nonatomic) UIView* storylineOpen;

- (void)layoutWithBlock:(Block*)block offsetY:(CGFloat)offsetY;
- (void) openWithAnimation;
- (void) closeWithAnimation;

@end
