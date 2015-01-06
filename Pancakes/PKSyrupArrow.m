//
//  PKSyrupArrow.m
//  Pancakes
//
//  Created by Leo on 06/01/2015.
//  Copyright (c) 2015 Gobelins. All rights reserved.
//

#import "PKSyrupArrow.h"

@implementation PKSyrupArrow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.alpha = 0.5f;
    [self setImage:[UIImage imageNamed:@"pkarrow"] forState:UIControlStateNormal];
    
    [UIView animateKeyframesWithDuration:2 delay:0.0 options: UIViewKeyframeAnimationOptionRepeat animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.1 animations:^{
            CGRect f = self.frame;
            f.origin.y -= 10;
            self.frame = f;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:0.1 animations:^{
            CGRect f = self.frame;
            f.origin.y += 15;
            self.frame = f;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.1 animations:^{
            CGRect f = self.frame;
            f.origin.y -= 5;
            self.frame = f;
        }];
    } completion:nil];
    
    return self;
}

@end
