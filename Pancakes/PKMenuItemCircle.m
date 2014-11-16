//
//  PKMenuItemCircle.m
//  Pancakes
//
//  Created by Glenn Sonna on 16/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "PKMenuItemCircle.h"

@implementation PKMenuItemCircle

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.alpha = 1;
        //self.layer.backgroundColor = [[UIColor redColor] CGColor];
        self.backgroundColor = [UIColor clearColor];
        self.check = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"check_item"]];
        self.check.image = [self.check.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.check setTintColor:[UIColor blackColor]] ;
        self.check.alpha = 0;
        self.check.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y -20, self.bounds.size.width, self.bounds.size.height );
    
    }
    return self;
}

- (void)layoutSubviews {
    [self setLayerProperties];
}

- (void)setLayerProperties {
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    [self addSubview:self.check];
    //[self.check setTintColor: [UIColor blackColor]];
}


//Here's how we animate the layer's path:
- (void)attacheSizeAnimationAsSelected : (BOOL)selected  {
    
    int size = selected ? -15 : 5;
    
    CABasicAnimation *animation = [self animationWithKeyPath:@"path"];
    animation.toValue = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, size, size)].CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:animation forKey:animation.keyPath];
}


- (CABasicAnimation *)animationWithKeyPath:(NSString *)keyPath {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.autoreverses = NO;
    animation.repeatCount = 0;
    animation.duration = 0.1f;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}


- (void)setSelected:(BOOL)selected completion: (void (^)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);{
    
    int alpha = selected ? 1 :0;
    int size = selected ? -5 : 5;
    int yPosition = selected ? self.bounds.origin.y  :-20;
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.check.alpha = alpha;
                //self.check.frame = CGRectMake(0 -10, -10, 20, 20);
                //self.check.frame = CGRectMake(0, yPosition, 20, 20);
                CGRect e = CGRectMake(self.bounds.origin.x, yPosition, self.bounds.size.width, self.bounds.size.height);
                self.check.frame = CGRectInset(e, size, size);
                
            } completion:completion];
        }];
        [self attacheSizeAnimationAsSelected:selected];
    } [CATransaction commit];
}


- (void)setUnSelected: (void (^)(void))block;{
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:block];
        [self attacheSizeAnimationAsSelected:NO];
    } [CATransaction commit];
}


/*
//Here's how we animate the layer's fill color:
- (void)attachColorAnimation {
    CABasicAnimation *animation = [self animationWithKeyPath:@"fillColor"];
    animation.fromValue = (__bridge id)[UIColor colorWithHue:0 saturation:.9 brightness:.9 alpha:1].CGColor;
    [self.layer addAnimation:animation forKey:animation.keyPath];
}*/

@end
