//
//  PKMenuItemCircle.h
//  Pancakes
//
//  Created by Glenn Sonna on 16/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKMenuItemCircle : UIView

@property(strong, nonatomic) UIImageView* check;

- (void)setSelected:(BOOL)selected completion: (void (^)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);
- (void)setUnSelected: (void (^)(void))block;
@end
