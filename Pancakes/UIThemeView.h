//
//  UIThemeView.h
//  Pancakes
//
//  Created by Glenn Sonna on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIThemeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *themeCheck;

-(void) setSwitchReceiverSelector: (SEL)action;

@end
