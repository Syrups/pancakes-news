//
//  AudioPlayer.h
//  Pancakes
//
//  Created by Leo on 15/12/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioPlayer : UIView

@property (strong, nonatomic) UIImageView* wave;

- (instancetype)initWithFrame:(CGRect)frame totalDuration:(CGFloat)total;
- (void)update;

@end
