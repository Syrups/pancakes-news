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
    
    [PKAIDecoder builAnimatedImageInButton:self fromFile:type.name withColor:color];
    
    UIImageView* background = [[UIImageView alloc] initWithFrame:frame];
    background.image = [UIImage imageNamed:@"article-block-button"];
    self.backgroundColor = [UIColor colorWithPatternImage:background.image];
    
    UIImage* picto = [UIImage imageNamed:[@"article-block-button-" stringByAppendingString:type.name]];
    [self setImage:[picto imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self setTintColor:color];
    
    [NSTimer scheduledTimerWithTimeInterval:1.3f target:self selector:@selector(reset) userInfo:nil repeats:NO];
    
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

@end
