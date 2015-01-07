//
//  ArticleParagraphLayoutManager.m
//  Pancakes
//
//  Created by Leo on 12/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ArticleParagraphLayoutManager.h"

@implementation ArticleParagraphLayoutManager

// Override to change distance between text and underline
- (void)underlineGlyphRange:(NSRange)glyphRange underlineType:(NSUnderlineStyle)underlineVal lineFragmentRect:(CGRect)lineRect lineFragmentGlyphRange:(NSRange)lineGlyphRange containerOrigin:(CGPoint)containerOrigin {
    [self drawUnderlineForGlyphRange:glyphRange underlineType:underlineVal baselineOffset:3.0f lineFragmentRect:lineRect lineFragmentGlyphRange:lineGlyphRange containerOrigin:containerOrigin];
}

@end
