//
//  DefinitionEmbeddedBlock.m
//  Pancakes
//
//  Created by Leo on 02/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "DefinitionEmbeddedBlock.h"
#import "Configuration.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"
#import "ArcImageView.h"

@implementation DefinitionEmbeddedBlock

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = kArticleEmbeddedBlockBorderColor.CGColor;
    self.layer.borderWidth = 1.0f;
    
    return self;
}

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    
    self.block = block;
    
    // Create the cover image of the embedded block
    ArcImageView* coverImage = [[ArcImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 160.0f) fullSize:NO];
    [coverImage sd_setImageWithURL:[NSURL URLWithString:block.image]];
    [self addSubview:coverImage];
    
    // Embedded block title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 20.0f, self.frame.size.width - 60.0f, 30.0f)];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:kFontBreeBold size:24.0f];
    title.textAlignment = NSTextAlignmentRight;
    title.text = block.title;
    [self addSubview:title];
    
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(30.0f, coverImage.frame.size.height+20.0f, self.frame.size.width-60.0f, 0.0f)];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:kArticleViewTextLineSpacing];
    
    for (NSString* p in block.paragraphs) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, offsetY, contentView.frame.size.width, 120.0f)];
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:kFontHeuristicaRegular size:18];
        
        NSMutableAttributedString* content = [[NSMutableAttributedString alloc] initWithString:p];
        
        [content addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
        
        label.attributedText = content;
        
        [label sizeToFit];
        [contentView addSubview:label];
        
        offsetY += 20.0f;
    }
    
    [contentView sizeToFit];
    [self addSubview:contentView];

}

@end
