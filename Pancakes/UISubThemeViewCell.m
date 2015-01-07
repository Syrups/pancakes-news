//
//  UISubThemeViewCell.m
//  Pancakes
//
//  Created by Glenn Sonna on 22/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "UISubThemeViewCell.h"
#import "UserDataHolder.h"


@implementation UISubThemeViewCell

- (void)awakeFromNib {
    // Initialization code
    //self.caption.lineBreakMode = NSLineBreakByWordWrapping;
    //self.caption.numberOfLines = 0;
    
    self.clipsToBounds = YES;
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

- (void)updateThemeColor:(UIColor *) color isIncluded :(BOOL) isInclude{
    
    self.themeColor = color;

    [self.title setText:self.subTheme.title];
    [self.title setTextColor:[UIColor blackColor]];
    
    [self.selectedFilter setBackgroundColor:[color colorWithAlphaComponent:isInclude ? 0.70 :0]];
    
    
    float transform = isInclude ? 1.0f : 5.0f;
    self.check.transform = CGAffineTransformMakeScale(transform, transform);
    self.check.alpha = isInclude ? 1 : 0;
    
    [self.zigzag setTintColor:color];

    self.cBack.backgroundColor = isInclude ? [UIColor clearColor] : [UIColor whiteColor];
    [self.title setTextColor: isInclude ? [UIColor whiteColor] : [UIColor blackColor]];
    
    self.separator.backgroundColor = isInclude ? [UIColor whiteColor] : [UIColor clearColor];
}


- (void)updateStatus{
    
    
    BOOL notIncluded = ![[[[UserDataHolder sharedInstance] user] interests] containsObject:self.subTheme._id];
    float transformIn = notIncluded ? 1.0f : 5.0f;
    
    //NSLog(@"before add %@ ", [[[[[UserDataHolder sharedInstance] user] interests] valueForKey:@"description"] componentsJoinedByString:@", "]);
    
    
    if(notIncluded){
        
        [[[[UserDataHolder sharedInstance] user] interests] addObject:self.subTheme._id];
    }else{
        
         [[[[UserDataHolder sharedInstance] user] interests] removeObject:self.subTheme._id];
    }
    
    //NSLog (notIncluded ? @"Adding : %@" : @"removing : %@", self.subTheme._id);
    
    //NSLog(notIncluded ?  @"after add : %@ " : @"after rem : %@ ", [[[[[UserDataHolder sharedInstance] user] interests] valueForKey:@"description"] componentsJoinedByString:@", "]);
    
    [UIView animateWithDuration:0.3 animations:^() {
        self.selectedFilter.backgroundColor = [self.themeColor colorWithAlphaComponent:notIncluded ? 0.70 :0];
        self.cBack.backgroundColor = notIncluded ? [UIColor clearColor] : [UIColor whiteColor];
        [self.title setTextColor: notIncluded ? [UIColor whiteColor] : [UIColor blackColor]];
        
         self.separator.backgroundColor = notIncluded ? [UIColor whiteColor] : [UIColor clearColor];
    }];
    
    //self.check.transform = CGAffineTransformMakeScale(5.0f, 5.0f);
    [UIView animateWithDuration:0.2f animations:^{
        self.check.transform = CGAffineTransformMakeScale(transformIn, transformIn);
        self.check.alpha = notIncluded ? 1 : 0;
    }];
}

/*
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    NSLog (@"setHighlighted:%@ animated:%@", (highlighted?@"YES":@"NO"), (animated?@"YES":@"NO"));
}
*/
@end
