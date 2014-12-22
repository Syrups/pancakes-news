//
//  AudioPlayer.m
//  Pancakes
//
//  Created by Leo on 15/12/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "AudioPlayer.h"
#import "Configuration.h"
#import "PKAIDecoder.h"

@implementation AudioPlayer {
    CGFloat currentTime;
    CGFloat totalDuration;
}

- (instancetype) initWithFrame:(CGRect)frame totalDuration:(CGFloat)total {
    currentTime = 0.0f;
    totalDuration = total;
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView* wave = [[UIImageView alloc] initWithFrame:CGRectMake(-130, -50, 441, 232)];
    [PKAIDecoder builAnimatedImageIn:wave fromFile:@"audio_wave"];
    [wave setContentMode:UIViewContentModeScaleAspectFit];
    
    self.wave = wave;
    [self addSubview:wave];
    
    [self setContentMode:UIViewContentModeRedraw];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    
    CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // outer circle
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, self.frame.size.width/2.5f - 11, -M_PI_2, [self getAnglePercent], 0);
    CGContextSetStrokeColorWithColor(ctx, RgbaColor(255, 255, 255, 0.2f).CGColor);
    CGContextSetLineWidth(ctx, 12.0f);
    CGContextStrokePath(ctx);
    
    NSLog(@"%f", [self getAnglePercent]);
    
    // inner circle
//    CGContextBeginPath(ctx);
//    CGContextAddArc(ctx, center.x, center.y, self.frame.size.width/2.5f - 16 , 0, 2*M_PI, 0);
//    CGContextSetStrokeColorWithColor(ctx, RgbaColor(255, 255, 255, 0.3f).CGColor);
//    CGContextSetLineWidth(ctx, 3.0f);
//    CGContextStrokePath(ctx);
    
    // bg
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, self.frame.size.width/2.5f - 18 , 0, 2*M_PI, 0);
    CGContextSetFillColorWithColor(ctx, RgbaColor(255, 255, 255, 0.6f).CGColor);
    CGContextFillPath(ctx);
    
    [super drawRect:rect];
    
}

- (CGFloat)getAnglePercent {
    return -M_PI_2 + (M_PI*2 * currentTime) / totalDuration;
}

- (void)update {
    
    if (totalDuration <= currentTime) return;
    
    currentTime += 0.1f;
    [self setNeedsDisplay];
    [self setContentMode:UIViewContentModeRedraw];
}

@end
