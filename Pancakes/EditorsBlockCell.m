//
//  EditorsBlockCell.m
//  Pancakes
//
//  Created by Leo on 03/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "EditorsBlockCell.h"
#import "Configuration.h"
#import "ArcImageView.h"
#import <UIImageView+WebCache.h>

@implementation EditorsBlockCell

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    if (self.opened) return;
    CGFloat y = 0;
    
    
    for (NSDictionary* editor in block.editors) {
        UIView* editorView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width, 450.0f)];
        CALayer *upperBorder = [CALayer layer];
        upperBorder.backgroundColor = RgbColor(223, 223, 223).CGColor;
        upperBorder.frame = CGRectMake(0, CGRectGetHeight(editorView.frame) - 1, CGRectGetWidth(editorView.frame), 1.0f);
        [editorView.layer addSublayer:upperBorder];
        editorView.backgroundColor = [UIColor whiteColor];
                              
        ArcImageView* cover = [[ArcImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 180.0f) fullSize:YES];
        [cover setImage:[UIImage imageNamed:@"splash"]];
        [editorView addSubview:cover];
        
        UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 65, 60, 130, 130)];
        [image sd_setImageWithURL:[NSURL URLWithString:[editor objectForKey:@"image"]]];
        image.layer.cornerRadius = 65;
        image.layer.masksToBounds = YES;
        [editorView addSubview:image];
        image.contentMode = UIViewContentModeScaleAspectFill;
        
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 180, self.frame.size.width - 100.0f, 30)];
        title.text = [editor objectForKey:@"title"];
        title.textColor = RgbColor(51, 51, 51);
        title.font = [UIFont fontWithName:kFontBreeBold size:20];
        [editorView addSubview:title];
        
        UILabel* bio = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 220, self.frame.size.width - 100.0f, 200)];
        NSMutableAttributedString* bioString = [[NSMutableAttributedString alloc] initWithString:[editor objectForKey:@"bio"]];
        NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:6.0f];
        [bioString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, bioString.length)];
        
        bio.attributedText = bioString;
        bio.textColor = RgbColor(51, 51, 51);
        bio.font = [UIFont fontWithName:kFontHeuristicaRegular size:18];
        bio.numberOfLines = 0;
        [editorView addSubview:bio];
        
        [self addSubview:editorView];
        
        y += editorView.frame.size.height + 20.0f;
    }
    
    [super layoutWithBlock:block offsetY:offsetY];
    
    self.backgroundColor = kArticleViewBlockBackground;
}

@end
