//
//  ChooseThemesViewController.h
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIThemeView.h"
#import "UISubThemeViewCell.h"
#import "SubThemeInterest.h"
#import "ThemeInterest.h"

@interface ChooseThemesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *themesView;
@property (strong, nonatomic) IBOutlet UITableView *subThemesView;
@property (strong, nonatomic) IBOutlet UITextView * themeDescription;
@property (strong, nonatomic) IBOutlet FXBlurView *topBlurView;
@property (strong, nonatomic) IBOutlet FXBlurView *bottomBlurView;

@property (weak, nonatomic) IBOutlet UILabel *currentPageNum;
//@property (nonatomic, retain) NSMutableArray* tableData;
@property (nonatomic, retain) NSMutableArray* themesData;
@property (nonatomic, retain) ThemeInterest* currentTheme;
@property (nonatomic, retain) NSArray<SubThemeInterest>* currentThemeSubs;
//@property (nonatomic) NSUInteger* currentPageNumber;



- (void) setThemeState :(id)sender  ;

@end
