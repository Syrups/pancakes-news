//
//  ArcImageView.m
//  Pancakes
//
//  Created by Leo on 24/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ArcImageView.h"
#import "Configuration.h"

@implementation ArcImageView {
    BOOL isFullSize;
}

- (instancetype)initWithFrame:(CGRect)frame fullSize:(BOOL)full {
    
    self = [super initWithFrame:frame];
    
    isFullSize = full;
    
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    
    if (!full) {
        CGPathAddLineToPoint(path, NULL, -1500, -200);
        CGPathAddArcToPoint(path, NULL, self.frame.size.width/2, 160, self.frame.size.width+1500, -200, 1400);
    } else {
        CGPathAddLineToPoint(path, NULL, -800, -120);
        CGPathAddArcToPoint(path, NULL, self.frame.size.width/2, self.bounds.size.height, self.frame.size.width+800, -120, 1400);
    }

    CGPathAddLineToPoint(path, NULL, self.frame.size.width, 0);
    CGPathAddLineToPoint(path, NULL, 0, 0);
    layer.path = path;
    CGPathRelease(path);
    
    self.layer.mask = layer;
    self.layer.masksToBounds = YES;
    
    return self;
}

- (void)bounce {
    
    if (!isFullSize) return;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, -1000, 0);
    
    CGPathAddArcToPoint(path, NULL, self.frame.size.width/2, self.bounds.size.height-20.0f, self.frame.size.width+1000, 0, 3000);
    
    
    CGPathAddLineToPoint(path, NULL, self.frame.size.width, 0);
    CGPathAddLineToPoint(path, NULL, 0, 0);
    
//    [(CAShapeLayer*)self.layer.mask setPath:path];
    
    CGPathRef oldPath = ([(CAShapeLayer*)self.layer.mask path]);
    
    [(CAShapeLayer*)self.layer.mask setPath:path];
    
    CABasicAnimation* bounceAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    bounceAnimation.fromValue = [NSValue value:oldPath withObjCType:@encode(CGPathRef)];
    bounceAnimation.toValue = [NSValue value:path withObjCType:@encode(CGPathRef)];
    bounceAnimation.duration = 0.15f;
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [(CAShapeLayer*)self.layer.mask addAnimation:bounceAnimation forKey:@"path"];
    
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        
//    } completion:nil];
    
//    CGPathRelease(oldPath);
    CGPathRelease(path);
}

- (void)reset {
    if (!isFullSize) return;
    
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, -1000, -120);
    CGPathAddArcToPoint(path, NULL, self.frame.size.width/2, self.bounds.size.height, self.frame.size.width+1000, -120, 1400);
    
    CGPathAddLineToPoint(path, NULL, self.frame.size.width, 0);
    CGPathAddLineToPoint(path, NULL, 0, 0);
    layer.path = path;
    CGPathRelease(path);
    
    self.layer.mask = layer;
    self.layer.masksToBounds = YES;
}

@end
