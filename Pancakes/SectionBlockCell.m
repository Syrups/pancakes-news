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

@implementation SectionBlockCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    
    if (self.opened) return;
    
    UIImageView *coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 8.0f, self.frame.size.width, 290.0f)];
    coverImage.contentMode = UIViewContentModeScaleAspectFit;
    [coverImage sd_setImageWithURL:[NSURL URLWithString:block.image]];
    [self addSubview:coverImage];
    
    self.coverImage = coverImage;
    
    UIView *imageMask = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 290.0f)];
    imageMask.backgroundColor = kArticleViewBlockBackground;
    [self addSubview:imageMask];
    
    self.imageMask = imageMask;
     
    UIView *titleBanner = [[UIView alloc] initWithFrame:CGRectMake(-1.0f, 15.0f, self.frame.size.width + 2.0f, 50.0f)];
    titleBanner.backgroundColor = [UIColor whiteColor];
    titleBanner.layer.borderColor = kArticleViewSectionBannerBorderColor.CGColor;
    titleBanner.layer.borderWidth = 1.0f;
    [self addSubview:titleBanner];
    
    self.titleBanner = titleBanner;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 15.0f, self.frame.size.width - 110.0f, 50.0f)];
    titleLabel.text = block.title;
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.font = [UIFont fontWithName:kFontBreeBold size:24.0f];
    titleLabel.textColor = [Utils colorWithHexString:[self.articleViewController.displayedArticle color]];
    NSLog(@"%@", self.articleViewController.displayedArticle.color);
    [self addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    
    UIView *storyline = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 38.0f, 0.0f, 1.0f, self.frame.size.height)];
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
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 67.0f, 10.0f, 60, 60)];
    [button setImage:[UIImage imageNamed:@"article-block-button-map"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reveal:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    self.revealButton = button;
    
    [super layoutWithBlock:block offsetY:300.0f];
    
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
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect f = self.titleBanner.frame;
        f.origin.y += f.size.height;
        f.size.height = 0.0f;
        self.titleBanner.frame = f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect f = self.titleLabel.frame;
            f.origin.y += 60.0f;
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
            [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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
                
            } completion:^(BOOL finished) {
                self.opened = true;
            }];
        }];
    }];
    
    self.layer.borderColor = kArticleEmbeddedBlockBorderColor.CGColor;
    self.layer.borderWidth = 1.0f;
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
