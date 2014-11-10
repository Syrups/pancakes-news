//
//  UISubThemeViewCell.m
//  Pancakes
//
//  Created by Glenn Sonna on 22/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "UISubThemeViewCell.h"


@implementation UISubThemeViewCell

- (void)awakeFromNib {
    // Initialization code
    //self.caption.lineBreakMode = NSLineBreakByWordWrapping;
    //self.caption.numberOfLines = 0;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.picture.contentMode = UIViewContentModeScaleAspectFill;
    self.picture.clipsToBounds = YES;
    
    //CGRect rect = self.picture.frame;
    //rect.size.width = 10;
    //self.picture.frame = rect;
    
    self.zigzag.image = [self.zigzag.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateThemeColor:(UIColor *) color {
    
    [self.title setText:self.subTheme.title];
    [self.title setTextColor:[UIColor blackColor]];
    
    [self.selectedFilter setBackgroundColor:color];
    self.selectedFilter.alpha = self.isIncluded ? 0.70 : 0;
    
    [self.zigzag setTintColor:color];
    
    
    
    self.backgroundColor = self.isIncluded ? [UIColor clearColor] : [UIColor whiteColor];
    [self.title setTextColor: self.isIncluded ? [UIColor whiteColor] : [UIColor blackColor]];


}


- (void)updateStatus{
    
    [self setIsIncluded: !self.isIncluded];
    
    [UIView animateWithDuration:0.3 animations:^() {
        self.selectedFilter.alpha = self.isIncluded ? 0.70 : 0;
        self.backgroundColor = self.isIncluded ? [UIColor clearColor] : [UIColor whiteColor];
        [self.title setTextColor: self.isIncluded ? [UIColor whiteColor] : [UIColor blackColor]];
    }];
    
   
    
    NSLog (self.isIncluded?@"YES":@"NO");

}

/*
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    NSLog (@"setHighlighted:%@ animated:%@", (highlighted?@"YES":@"NO"), (animated?@"YES":@"NO"));
}
*/
@end
