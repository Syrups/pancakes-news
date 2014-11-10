//
//  UIThemeView.h
//  Pancakes
//
//  Created by Glenn Sonna on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeInterest.h"

@interface UIThemeView : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *themeCheck;
@property (weak, nonatomic) ThemeInterest *theme;

- (void) setSwitchReceiverSelector: (SEL)action;
- (void) updateCellWithImage :  (NSString *)imageName ;
- (void) updateAsNotfullyVisible;

@end
