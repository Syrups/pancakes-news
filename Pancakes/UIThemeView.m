//
//  UIThemeView.m
//  Pancakes
//
//  Created by Glenn Sonna on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "UIThemeView.h"
#import "UIImage+StackBlur.h"

@implementation UIThemeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    // Initialization code
    //self.caption.lineBreakMode = NSLineBreakByWordWrapping;
    //self.caption.numberOfLines = 0;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
}

-(void)updateCellWithImage: (NSString *)imageName {
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [tempImageView setFrame:self.frame];
    self.backgroundView = tempImageView;
}



- (void) updateAsNotfullyVisible{
    UIImage *baseImage = [UIImage imageNamed:self.theme.coverImage];
    UIImage *blurImage = [baseImage stackBlur:20];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:blurImage];
    [tempImageView setFrame:self.frame];
    
    self.backgroundView = tempImageView;
}

-(void) setSwitchReceiverSelector: (SEL)action{
}

/*
 - (UIThemeView*) getUIThemeView: (CGFloat) xOrigin{
 CGRect position = CGRectMake(0, xOrigin , self.scrollView.frame.size.width, self.scrollView.frame.size.height);
 //UIThemeView *themeView = [[[NSBundle mainBundle] loadNibNamed:@"UIThemeView" owner:self options:nil] objectAtIndex:0];
 [themeView setFrame:position];
 return themeView;
 }*/

/*for (int i = 0; i < numberOfViews; i++) {
 
 ThemeInterest *theme =[self.themesData objectAtIndex:i];
 CGFloat xOrigin = i * self.scrollView.frame.size.height ; //+ 40;
 //UIThemeView *view = [self getUIThemeView:xOrigin];
 UIImage *back = [UIImage imageNamed:theme.coverImage];
 //CGRect position = CGRectMake(0, xOrigin , self.scrollView.frame.size.width, self.scrollView.frame.size.height);
 //UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(0, xOrigin, self.view.frame.size.width/2, self.view.frame.size.height)];
 view.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
 
 
 //view.backgroundImage.image = back;
 
 //[view.backgroundImage setFrame:view.frame];
 
 [view.themeLabel setText:theme.title];
 [view.themeLabel setTextColor: [self colorWithHexString: theme.color]];
 
 [view.themeCheck addTarget:self action:@selector(setThemeState:) forControlEvents:UIControlEventValueChanged];
 
 [self.scrollView addSubview:view];
 //[categoriesViews addObject:view];
 }*/



@end
