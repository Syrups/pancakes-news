//
//  PKSyrupButton.h
//  Pancakes
//
//  Created by Glenn Sonna on 12/12/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define kInnerPadding 15.f

@interface PKSyrupButton : UIControl

typedef NS_ENUM(NSInteger, PKSyrupButtonType){
    PKSyrupButtonTypePlus,
    PKSyrupButtonTypeX
};


@property(assign, nonatomic)PKSyrupButtonType innerImageType;
@property(strong, nonatomic)UIView *innerImage;

@property(strong, nonatomic)UIColor *innerColor;
@property(strong, nonatomic)UIColor *innerImageColor;
@property(strong, nonatomic)UIColor *borderColor;
@property BOOL switchMode;
@property BOOL isOn;

@property BOOL isTouchDown;

@end
