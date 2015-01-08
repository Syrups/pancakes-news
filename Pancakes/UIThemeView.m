//
//  UIThemeView.m
//  Pancakes
//
//  Created by Glenn Sonna on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "UIThemeView.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)updateCellWithImage {
    
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.theme.coverImage ofType:@"gif"];
        NSData *gif = [NSData dataWithContentsOfFile:filePath];
    
        self.backgroundImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData : gif];
}



- (void) updateAsFullyVisible : (BOOL) visible{
    
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.effectView.alpha = !visible;
        
    } completion:^(BOOL finished) {
        if(visible){
            [self.backgroundImageView startAnimating];
        }else{
            [self.backgroundImageView stopAnimating];
        }
    }];
    
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
