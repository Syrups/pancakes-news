//
//  BlockButton.m
//  Pancakes
//
//  Created by Leo on 25/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "BlockButton.h"

@implementation BlockButton {
    BOOL isAnimatingAfterScroll;
}

- (instancetype) initWithFrame:(CGRect)frame blockType:(BlockType*)type color:(UIColor*)color {
    self = [super initWithFrame:frame];
    
    UIImageView* background = [[UIImageView alloc] initWithFrame:frame];
    background.image = [UIImage imageNamed:@"article-block-button"];
    self.backgroundColor = [UIColor colorWithPatternImage:background.image];
    
    UIImage* picto = [UIImage imageNamed:[@"article-block-button-" stringByAppendingString:type.name]];
    [self setImage:[picto imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self setTintColor:color];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"scroll.end" object:nil queue:nil usingBlock:^(NSNotification *note) {
        isAnimatingAfterScroll = YES;
        __block CGRect originalFrame = self.imageView.frame;

        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect f = self.imageView.frame;
            f.origin.y += 5.0f;
            [self.imageView setFrame:f];

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGRect f = self.imageView.frame;
                f.origin.y -= 5.0f;
                [self.imageView setFrame:f];
            } completion:^(BOOL finished) {
                [self.imageView setFrame:originalFrame];
                isAnimatingAfterScroll = NO;
            }];
        }];
    }];
    
    return self;
}

@end
