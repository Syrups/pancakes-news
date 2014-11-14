//
//  UILabel+Lettrine.m
//  Pancakes
//
//  Created by Leo on 13/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "UILabel+Lettrine.h"

@implementation UILabel (Lettrine)

- (void)makeLettrine {
    NSString* firstLetter = [self.attributedText.string substringToIndex:1];
    
    UILabel* lettrine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    UILabel* lettrineSide = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, self.frame.size.width - 150, 150)];
    UILabel* lettrineBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, self.frame.size.width, self.frame.size.height + 20.0f)];
    
    NSRange sideRange = NSMakeRange(1, 50);
    NSRange restRange = NSMakeRange(50, self.attributedText.length - 51);
    
    lettrine.text = firstLetter;
    lettrineSide.attributedText = [self.attributedText attributedSubstringFromRange:sideRange];
    lettrineBottom.attributedText = [self.attributedText attributedSubstringFromRange:restRange];
    
    self.attributedText = [[NSAttributedString alloc] initWithString:@""];

    [self addSubview:lettrine];
    [self addSubview:lettrineSide];
    [self addSubview:lettrineBottom];
}

@end
