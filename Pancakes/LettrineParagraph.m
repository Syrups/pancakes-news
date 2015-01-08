//
//  LettrineParagraph.m
//  Pancakes
//
//  Created by Leo on 13/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "LettrineParagraph.h"
#import "Configuration.h"

@implementation LettrineParagraph

- (instancetype) initWithFrame:(CGRect)frame {
    frame.size.height += 40.0f; // make space lost by the lettrine
    
    self = [super initWithFrame:frame];
    
    return self;
}

- (void)layoutWithAttributedString:(NSAttributedString*)attributedText color:(UIColor *)color {
    NSString* firstLetter = [attributedText.string substringToIndex:1];
    
    firstLetter = [firstLetter lowercaseString];
    
    UILabel* lettrine = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 80, 80)];
    UILabel* lettrineSide = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, self.frame.size.width - 60, 70)];
    UILabel* lettrineBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.frame.size.width - 5, self.frame.size.height + 20.0f)];
    
    NSUInteger offset = attributedText.length;
    
    lettrine.font = [UIFont fontWithName:kFontBreeBold size:135];
    lettrine.textColor = color;
    
    if (offset < 160) {
        NSRange sideRange = NSMakeRange(1, offset-1);
        NSMutableAttributedString* sideString = [attributedText attributedSubstringFromRange:sideRange].mutableCopy;
        lettrineSide.font = [UIFont fontWithName:kFontHeuristicaRegular size:18];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:kArticleViewTextLineSpacing];
        
        [sideString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, sideString.length)];
        
        lettrine.text = firstLetter;
        lettrineSide.attributedText = sideString;
        
        lettrine.numberOfLines = 0;
        lettrineSide.numberOfLines = 0;
        
        [lettrineSide sizeToFit];
        
        [self addSubview:lettrineSide];
    } else {
        NSRange sideRange = NSMakeRange(1, 160);
        NSRange restRange = NSMakeRange(161, attributedText.length - 161);
        
        NSString* rest = [[attributedText attributedSubstringFromRange:restRange].string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSMutableAttributedString* sideString = [attributedText attributedSubstringFromRange:sideRange].mutableCopy;
        NSMutableAttributedString* restString = [[NSMutableAttributedString alloc] initWithString:rest];
        
        
        
        lettrineSide.font = [UIFont fontWithName:kFontHeuristicaRegular size:18];
        lettrineBottom.font = [UIFont fontWithName:kFontHeuristicaRegular size:18];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:kArticleViewTextLineSpacing];
        
        [sideString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, sideString.length)];
        [restString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, restString.length)];
        
        lettrine.text = firstLetter;
        lettrineSide.attributedText = sideString;
        lettrineBottom.attributedText = restString;
        
        lettrine.numberOfLines = 0;
        lettrineSide.numberOfLines = 0;
        lettrineBottom.numberOfLines = 0;
        
        //    [lettrine sizeToFit];
        [lettrineSide sizeToFit];
        [lettrineBottom sizeToFit];
        
        
        [self addSubview:lettrineSide];
        [self addSubview:lettrineBottom];
    }
    
    [self addSubview:lettrine];
}

@end
