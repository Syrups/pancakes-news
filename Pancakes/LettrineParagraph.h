//
//  LettrineParagraph.h
//  Pancakes
//
//  Created by Leo on 13/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LettrineParagraph : UIView

- (void)layoutWithAttributedString:(NSAttributedString*)attributedText color:(UIColor*)color;

@end
