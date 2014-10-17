//
//  ChooseThemesViewController.h
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseThemesViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *currentPageNum;

@end
