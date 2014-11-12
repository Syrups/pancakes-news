//
//  UISubThemeViewCell.h
//  Pancakes
//
//  Created by Glenn Sonna on 22/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubThemeInterest.h"

@interface UISubThemeViewCell : UITableViewCell

@property (weak, nonatomic) SubThemeInterest *subTheme;

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextView *caption;

@property (assign, nonatomic) BOOL *isIncluded;
@property (weak, nonatomic) IBOutlet UIImageView *zigzag;
@property (weak, nonatomic) IBOutlet UIView *selectedFilter;


- (void)updateThemeColor:(UIColor *) color;
- (void)updateStatus;
@end