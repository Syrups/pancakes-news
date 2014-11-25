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
#import "Utils.h"
#import "UIImageView+WebCache.h"
#import "ArcImageView.h"
#import <FXBlurView/FXBlurView.h>
#import "BlockButton.h"

@implementation SectionBlockCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    
    if (self.opened) return;
    
    CAShapeLayer* mask = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint arcCenter = CGPointMake(0, 220);
    CGPathAddArc(path, NULL, arcCenter.x, arcCenter.y, 300, M_PI_2, -M_PI_2, NO);
    mask.path = path;
    CGPathRelease(path);
    
    ArcImageView *coverImage = [[ArcImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 240.0f) fullSize:YES];
    coverImage.contentMode = UIViewContentModeScaleToFill;
    [coverImage sd_setImageWithURL:[NSURL URLWithString:block.image]];
//    coverImage.layer.mask = mask;
    [self addSubview:coverImage];
    
    self.coverImage = coverImage;
    
//    UIView *imageMask = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 290.0f)];
//    imageMask.backgroundColor = kArticleViewBlockBackground;
//    [self addSubview:imageMask];
    
    FXBlurView *imageMask = [[FXBlurView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 200.0f)];
    imageMask.blurRadius = 8.0f;
    [self addSubview:imageMask];
    
    self.imageMask = imageMask;
     
    UIView *titleBanner = [[UIView alloc] initWithFrame:CGRectMake(-1.0f, 15.0f, self.frame.size.width + 2.0f, 50.0f)];
    titleBanner.backgroundColor = [UIColor whiteColor];
    titleBanner.layer.borderColor = kArticleViewSectionBannerBorderColor.CGColor;
    titleBanner.layer.borderWidth = 1.0f;
//    [self addSubview:titleBanner];
    
    self.titleBanner = titleBanner;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 5.0f, self.frame.size.width - 110.0f, 50.0f)];
    titleLabel.text = block.title;
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.font = [UIFont fontWithName:kFontBreeBold size:24.0f];
//    titleLabel.textColor = [Utils colorWithHexString:[self.articleViewController.displayedArticle color]];
    titleLabel.textColor = [UIColor whiteColor];
    NSLog(@"%@", self.articleViewController.displayedArticle.color);
    [self addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = RgbColor(35, 36, 32).CGColor;
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(coverImage.frame), 1.0f);
    [self.layer addSublayer:upperBorder];
    
    UIView *storyline = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 37.0f, 0.0f, 1.0f, self.frame.size.height)];
    storyline.backgroundColor = RgbColor(180, 180, 180);
    [self addSubview:storyline];
    
    
    UIView *storylineOpen = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 39.0f, 0.0f, 3.0f, 0.0f)];
    storylineOpen.backgroundColor = [Utils colorWithHexString:self.articleViewController.displayedArticle.color];
    [self addSubview:storylineOpen];
    
    self.storylineOpen = storylineOpen;
    
    UIButton* closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 56, 20.0f, 40, 40)];
    [closeButton setImage:[UIImage imageNamed:@"block-close"] forState:UIControlStateNormal];
    closeButton.backgroundColor = [Utils colorWithHexString:self.articleViewController.displayedArticle.color];
    closeButton.layer.cornerRadius = 20;
    closeButton.alpha = 0;
    closeButton.titleLabel.alpha = 0;
    [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    self.closeButton = closeButton;
    
    BlockButton* button = [[BlockButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 62.0f, 5.0f, 50, 50) blockType:block.type color:[Utils colorWithHexString:self.articleViewController.displayedArticle.color]];
    [button addTarget:self action:@selector(reveal:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
    self.revealButton = button;
    
    [super layoutWithBlock:block offsetY:200.0f];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)reveal:(UIButton*)sender {
    NSIndexPath* indexPath = [self.articleViewController.collectionView indexPathForCell:self];
    
    [self.articleViewController revealBlockAtIndexPath:indexPath];
    [self.articleViewController.scrollListeners addObject:self];
}

- (void)close:(UIButton*)sender {
    NSIndexPath* indexPath = [self.articleViewController.collectionView indexPathForCell:self];
    
    [self.articleViewController closeBlockAtIndexPath:indexPath];
}

- (void)openWithAnimation {
    [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect f = self.titleBanner.frame;
        f.origin.y += f.size.height;
        f.size.height = 0.0f;
        self.titleBanner.frame = f;
        self.imageMask.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect f = self.titleLabel.frame;
            f.origin.y += 65.0f;
            self.titleLabel.frame = f;
            self.titleLabel.textColor = [UIColor whiteColor];
            
            f = self.revealButton.frame;
            f.origin.y += 60.0f;
            self.revealButton.frame = f;
            f = self.closeButton.frame;
            f.origin.y += 60.0f;
            self.closeButton.frame = f;
            self.closeButton.alpha = 1;
            self.revealButton.alpha = 0;
            self.revealButton.transform = CGAffineTransformMakeRotation(M_PI);
            
            f = self.imageMask.frame;
            f.origin.y += 350.0f;
            self.imageMask.frame = f;
        } completion:^(BOOL finished) {
            [self.coverImage bounce];
            [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.contentView.alpha = 1.0f;
                
                CGRect f = self.titleLabel.frame;
                f.origin.y -= 10.0f;
                self.titleLabel.frame = f;
                
                f = self.closeButton.frame;
                f.origin.y -= 10.0f;
                self.closeButton.frame = f;
                self.closeButton.titleLabel.alpha = 1;
                self.imageMask.alpha = 0.0f;
                
                f = self.storylineOpen.frame;
                f.size.height = self.frame.size.height;
                self.storylineOpen.frame = f;
                
                CALayer *lowerBorder = [CALayer layer];
                lowerBorder.backgroundColor = RgbColor(183, 183, 183).CGColor;
                lowerBorder.frame = CGRectMake(0, self.frame.size.height-1, CGRectGetWidth(self.frame), 1.0f);
                [self.layer addSublayer:lowerBorder];
                
            } completion:^(BOOL finished) {
                self.opened = true;
            }];
        }];
    }];
}

- (void)closeWithAnimation {
    self.opened = false;
    self.layer.borderWidth = 0.0f;
}

#pragma mark - Scroll view listener

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = self.closeButton.frame;
    frame.origin.y = scrollView.contentOffset.y;
    self.closeButton.frame = frame;
}

@end
