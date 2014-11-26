//
//  CommentsBlockCell.m
//  Pancakes
//
//  Created by Leo on 15/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "CommentsBlockCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <FXBlurView/FXBlurView.h>
#import "Configuration.h"
#import "Comment.h"
#import "ArcImageView.h"

@implementation CommentsBlockCell

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    if (self.opened) return;
    
    ArcImageView* cover = [[ArcImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150.0f) fullSize:YES];
    [cover sd_setImageWithURL:[NSURL URLWithString:self.articleViewController.displayedArticle.coverImage]];
    [self addSubview:cover];
    
    FXBlurView* blur = [[FXBlurView alloc] initWithFrame:cover.frame];
    [blur setBlurRadius:8.0f];
    [self addSubview:blur];
    
    offsetY += 130.0f;
    
    for (Comment* comment in self.articleViewController.displayedArticle.comments) {
        UIView* commentBlock = [[UIView alloc] initWithFrame:CGRectMake(25.0f, offsetY, self.bounds.size.width - 80.0f, 100.0f)];
        commentBlock.backgroundColor = RgbColor(253, 253, 253);
        commentBlock.layer.borderColor = RgbColor(222, 222, 222).CGColor;
        commentBlock.layer.borderWidth = 1.0f;
        
        UILabel* content = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, commentBlock.bounds.size.width - 20, 80)];
        content.numberOfLines = 0;
        content.font = [UIFont fontWithName:kFontHeuristicaRegular size:16];
        content.text = comment.content;
        [commentBlock addSubview:content];
        
        [self addSubview:commentBlock];
        
        offsetY += commentBlock.bounds.size.height + 40.0f;
    }
    
    [super layoutWithBlock:block offsetY:offsetY];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld Comments", self.articleViewController.displayedArticle.comments.count];
    
    self.backgroundColor = kArticleViewBlockBackground;
}

@end
