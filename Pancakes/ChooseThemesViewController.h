//
//  ChooseThemesViewController.h
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIThemeView.h"

@interface ChooseThemesViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *subThemesView;
@property (weak, nonatomic) IBOutlet UILabel *currentPageNum;
//@property (nonatomic, retain) NSMutableArray* tableData;
@property (nonatomic, retain) NSArray* themesData;
@property (nonatomic, retain) NSDictionary* currentTheme;
@property (nonatomic, retain) NSArray* currentThemeSubs;

- (UIThemeView*) getUIThemeView: (CGFloat) xOrigin;

@end
