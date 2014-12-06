//
//  UIThemeView.h
//  Pancakes
//
//  Created by Glenn Sonna on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

@import MediaPlayer;
@import UIKit;

#import "ThemeInterest.h"
#import "FXBlurView.h"

@interface UIThemeView : UITableViewCell
@property (strong, nonatomic) UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIWebView *webViewBG;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *themeCheck;
//@property (weak, nonatomic) IBOutlet FXBlurView *blurView;
@property (weak, nonatomic) ThemeInterest *theme;

- (void) setSwitchReceiverSelector: (SEL)action;
- (void) updateCellWithImage :  (NSString *)imageName ;
- (void) updateAsFullyVisible : (BOOL) visible;

@end
