//
//  BlockButton.m
//  Pancakes
//
//  Created by Leo on 25/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "BlockButton.h"
#import "PKAIDecoder.h"

@implementation BlockButton {
    BOOL isAnimatingAfterScroll;
}

- (instancetype) initWithFrame:(CGRect)frame blockType:(BlockType*)type color:(UIColor*)color {
    self = [super initWithFrame:frame];
    
    self.type = type;
    self.color = color;
    
    if (![type.name isEqualToString:@"slide"]) {
        [PKAIDecoder builAnimatedImageInButton:self fromFile:type.name withColor:color];
    } else {
        [self setImage:[[UIImage imageNamed:@"article-block-button-slide"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.imageView.tintColor = self.color;
    }
    
    UIImageView* background = [[UIImageView alloc] initWithFrame:frame];
    background.image = [UIImage imageNamed:@"article-block-button"];
    self.backgroundColor = [UIColor colorWithPatternImage:background.image];
    
     [self setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    
    //UIImage* picto = [UIImage imageNamed:[@"article-block-button-" stringByAppendingString:type.name]];
    //[self setImage:[picto imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    //[self setTintColor:color];
    
    if (![type.name isEqualToString:@"slide"]) {
        [NSTimer scheduledTimerWithTimeInterval:1.3f target:self selector:@selector(reset) userInfo:nil repeats:NO];
    
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(repeat) userInfo:nil repeats:YES];
    }

    
//    [[NSNotificationCenter defaultCenter] addObserverForName:@"scroll.end" object:nil queue:nil usingBlock:^(NSNotification *note) {
//        
//        if (!isAnimatingAfterScroll) {
//            
//        }
//        
//    }];
    
    return self;
}

- (void) reset {

    NSArray* images = [PKAIDecoder decodeImageFromFile:self.type.name];
    
    if (images.count > 0) {
        UIImage* picto = [images objectAtIndex:images.count-1];
        [self setImage:[picto imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self setTintColor:self.color];
    }
}

- (void)repeat {
    [PKAIDecoder builAnimatedImageInButton:self fromFile:self.type.name withColor:self.color];
    [NSTimer scheduledTimerWithTimeInterval:1.3f target:self selector:@selector(reset) userInfo:nil repeats:NO];
}

@end
