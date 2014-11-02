//
//  SectionBlockCell.m
//  Pancakes
//
//  Created by Leo on 31/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "SectionBlockCell.h"
#import "Configuration.h"
#import "Macros.h"
#import "UIImageView+WebCache.h"

@implementation SectionBlockCell {
    BOOL opened;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    
    if (opened) return;
    
    UIImageView *coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 8.0f, self.frame.size.width, 290.0f)];
    coverImage.contentMode = UIViewContentModeScaleAspectFit;
    [coverImage sd_setImageWithURL:[NSURL URLWithString:block.image]];
    [self addSubview:coverImage];
    
    self.coverImage = coverImage;
    
    UIView *imageMask = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 290.0f)];
    imageMask.backgroundColor = kArticleViewBlockBackground;
    [self addSubview:imageMask];
    
    self.imageMask = imageMask;
     
    UIView *titleBanner = [[UIView alloc] initWithFrame:CGRectMake(-1.0f, 20.0f, self.frame.size.width + 2.0f, 45.0f)];
    titleBanner.backgroundColor = [UIColor whiteColor];
    titleBanner.layer.borderColor = kArticleViewSectionBannerBorderColor.CGColor;
    titleBanner.layer.borderWidth = 1.0f;
    [self addSubview:titleBanner];
    
    self.titleBanner = titleBanner;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 20.0f, self.frame.size.width - 110.0f, 50.0f)];
    titleLabel.text = block.title;
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.font = [UIFont fontWithName:kFontBreeBold size:24.0f];
    titleLabel.textColor = kOrangeColor;
    [self addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    
    [super layoutWithBlock:block offsetY:300.0f];
}

- (void)openWithAnimation {
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect f = self.titleBanner.frame;
        f.origin.y += f.size.height;
        f.size.height = 0.0f;
        self.titleBanner.frame = f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect f = self.titleLabel.frame;
            f.origin.y += 40.0f;
            self.titleLabel.frame = f;
            self.titleLabel.textColor = [UIColor whiteColor];
            
            f = self.imageMask.frame;
            f.origin.y += 350.0f;
            self.imageMask.frame = f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.contentView.alpha = 1.0f;
                self.imageMask.alpha = 0.0f;
            } completion:^(BOOL finished) {
                opened = true;
            }];
        }];
    }];
}

- (void)closeWithAnimation {
    opened = false;
}

@end
