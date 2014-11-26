//
//  ArcImageView.h
//  Pancakes
//
//  Created by Leo on 24/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArcImageView : UIImageView

- (instancetype)initWithFrame:(CGRect)frame fullSize:(BOOL)full;
- (void)bounce;
- (void)reset;

@end
