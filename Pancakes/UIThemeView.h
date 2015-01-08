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
#import "FLAnimatedImageView.h"
#import "PKSyrupButton.h"

@interface UIThemeView : UITableViewCell
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet PKSyrupButton *themeCheck;
@property (weak, nonatomic) ThemeInterest *theme;

- (void) setSwitchReceiverSelector: (SEL)action;
- (void) updateCellWithImage;
//- (void) updateCellWithImage :  (NSString *)imageName ;
- (void) updateAsFullyVisible : (BOOL) visible;

@end
