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

@interface ChooseThemesViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *subThemesView;
@property (strong, nonatomic) IBOutlet UITextView * themeDescription;
@property (weak, nonatomic) IBOutlet UILabel *currentPageNum;
//@property (nonatomic, retain) NSMutableArray* tableData;
@property (nonatomic, retain) NSMutableArray* themesData;
@property (nonatomic, retain) NSDictionary* currentTheme;
@property (nonatomic, retain) NSArray* currentThemeSubs;
//@property (nonatomic) NSUInteger* currentPageNumber;



- (UIThemeView*) getUIThemeView: (CGFloat) xOrigin;
- (void) setThemeState :(id)sender  ;

@end
