//
//  SlideshowEmbeddedBlock.m
//  Pancakes
//
//  Created by Leo on 08/01/2015.
//  Copyright (c) 2015 Gobelins. All rights reserved.
//

#import "SlideshowEmbeddedBlock.h"
#import "Configuration.h"
#import <UIImageView+WebCache.h>

@implementation SlideshowEmbeddedBlock

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    
//    NSLog(@"%@", block.images);
//    
//    for (int i = 0 ; i < block.images.count ; i++) {
//        CGRect frame = self.scrollView.frame;
//        frame.origin.x = i*frame.size.width;
//        UIImageView* image = [[UIImageView alloc] initWithFrame:frame];
//        [image sd_setImageWithURL:[NSURL URLWithString:block.images[i]]];
//        
//        [self.imageViews addObject:image];
//        [self.scrollView addSubview:image];
//        
//    }
//    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.imageViews.count, self.scrollView.frame.size.height);
//    self.scrollView.contentOffset = CGPointMake(200, 0);

    for (int i = 0; i < block.images.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [image sd_setImageWithURL:[NSURL URLWithString:block.images[i]]];
        [self.imageViews addObject:image];
        image.contentMode = UIViewContentModeScaleAspectFill;
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        [subview addSubview:image];
        [self.scrollView addSubview:subview];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * block.images.count, self.scrollView.frame.size.height);
    
    [self addSubview:self.scrollView];
    
    // Embedded block title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 20.0f, self.frame.size.width - 60.0f, 30.0f)];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:kFontBreeBold size:24.0f];
    title.textAlignment = NSTextAlignmentRight;
    title.text = block.title;
    [self addSubview:title];
    [self bringSubviewToFront:title];
}

- (void)zoom:(UIGestureRecognizer*)sender {
    UIImageView* full = [self.imageViews objectAtIndex:0];
    full.frame = [UIScreen mainScreen].bounds;
    [self addSubview:full];
    NSLog(@"Touch");
}

@end
