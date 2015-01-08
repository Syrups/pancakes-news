//
//  CommentsBlockCell.m
//  Pancakes
//
//  Created by Leo on 15/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "CommentsBlockCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Configuration.h"
#import "Comment.h"
#import "ArcImageView.h"

@implementation CommentsBlockCell

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    if (self.opened) return;
    
    self.blurEnabled = NO;
    
    ArcImageView* cover = [[ArcImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150.0f) fullSize:YES];
    [cover sd_setImageWithURL:[NSURL URLWithString:self.articleViewController.displayedArticle.coverImage]];
    cover.tintColor = RgbaColor(0, 0, 0, 0.5);
    [self addSubview:cover];
    
    
    offsetY += 130.0f;
    
    for (Comment* comment in self.articleViewController.displayedArticle.comments) {
        
        UIView* commentBlock = [[UIView alloc] initWithFrame:CGRectMake(40.0f, offsetY, self.bounds.size.width - 110.0f, 150.0f)];
        commentBlock.backgroundColor = RgbColor(253, 253, 253);
        commentBlock.layer.borderColor = RgbColor(222, 222, 222).CGColor;
        commentBlock.layer.borderWidth = 1.0f;
        
        UIImageView* pic = [[UIImageView alloc] initWithFrame:CGRectMake(commentBlock.bounds.size.width/2-42, -42, 85, 85)];
        pic.image = [UIImage imageNamed:@"glenn"];
        pic.layer.cornerRadius = 42.5f;
        pic.layer.masksToBounds = YES;
        [commentBlock addSubview:pic];
        
        UILabel* author = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, commentBlock.bounds.size.width - 20, 15)];
        author.numberOfLines = 0;
        author.font = [UIFont fontWithName:kFontBreeBold size:18];
        author.text = @"Glenn Sonna";
        [commentBlock addSubview:author];
        
        UIImageView* wave = [[UIImageView alloc] initWithFrame:CGRectMake(20, 55, 30, 6)];
        wave.image = [UIImage imageNamed:@"gouigoui"];
        [commentBlock addSubview:wave];
        
        UILabel* content = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, commentBlock.bounds.size.width - 20, 80)];
        content.contentMode = UIViewContentModeTop;
        content.numberOfLines = 0;
        content.font = [UIFont fontWithName:kFontHeuristicaRegular size:18];
        content.text = comment.content;
        [commentBlock addSubview:content];
        
        [self addSubview:commentBlock];
        
        offsetY += commentBlock.bounds.size.height + 60.0f;
    }
    
    [super layoutWithBlock:block offsetY:offsetY];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld Comments", self.articleViewController.displayedArticle.comments.count];
    
    self.backgroundColor = kArticleViewBlockBackground;
}

@end
