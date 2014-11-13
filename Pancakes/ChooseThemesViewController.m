//
//  ChooseThemesViewController.m
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ChooseThemesViewController.h"
#import "UIImage+StackBlur.h"
#import "Configuration.h"
#import "UserDataHolder.h"
#import "JSONModel/JSONModelNetworking/JSONHTTPClient.h"


@interface ChooseThemesViewController ()

@end

@implementation ChooseThemesViewController {
    NSMutableArray* categoriesViews;
}

NSString * const themesUrl = kApiRootUrl @"/themes";
NSString * const CellIdentifier = @"SubThemeViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //InitScrollView and TableView
    int screenMidSize = self.view.frame.size.width/2;
    int screenHeight = self.view.frame.size.height;
    
    
    self.themesView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, screenMidSize, screenHeight - kMenuBarHeigth)];
    self.subThemesView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, screenMidSize, screenHeight)];
    self.themeDescription = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, screenMidSize, screenHeight)];
    
    self.themeDescription.textContainerInset = UIEdgeInsetsMake(30, 30, 30, 30);
    self.themeDescription.font = [UIFont fontWithName:@"Heuristica-Regular" size:15.5];
    self.themeDescription.textColor = [self colorWithHexString:@"322e1d"];
    self.themeDescription.selectable = NO;
    
    [self.subThemesView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    [self.subThemesView setDelegate:self];
    [self.themesView setDelegate:self];
    
    [self.subThemesView setDataSource:self];
    [self.themesView setDataSource:self];
    
    
    [self.view addSubview:self.themesView];
    [self.view addSubview:self.subThemesView];
    [self.view addSubview: self.themeDescription];
    
    [self loadThemesFromNetwork];
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.subThemesView.frame = CGRectMake(screenMidSize, 0, screenMidSize, screenHeight);
        self.themeDescription.frame = CGRectMake(screenMidSize, 0, screenMidSize, screenHeight);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f  delay:0 options: UIViewAnimationOptionCurveEaseInOut animations:^() {
            self.themesView.frame = CGRectMake(0, kMenuBarHeigth, screenMidSize, screenHeight - kMenuBarHeigth);
            
        } completion:nil];
    }];
}


#pragma mark - UIScrollView


-(void) updateThemeDataWithCell : (UIThemeView *) cell{
    //[self.subThemesView reloadData];
    // The key is repositioning without animation
    
    self.currentTheme = cell.theme;
    self.currentThemeSubs = self.currentTheme.subthemes;
    self.themeDescription.text = self.currentTheme.desc;
    
    [UIView animateWithDuration:0.3 animations:^() {
        self.themeDescription.alpha =  cell.self.themeCheck.isOn ? 0 : 1.0;
        //[self.themeDescription setHidden:view.self.themeCheck.isOn];
        UIImage *baseImage = [UIImage imageNamed:self.currentTheme.coverImage];
        UIImage *blurImage = [baseImage stackBlur:20];
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:blurImage];
        [tempImageView setFrame:self.subThemesView.frame];
        self.subThemesView.backgroundView = tempImageView;
        
    }];
    
    
    [self.subThemesView  reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.3];
    
    
    if (scrollView == self.themesView) {
        
        CGFloat currentOffsetX = scrollView.contentOffset.x;
        CGFloat currentOffSetY = scrollView.contentOffset.y;
        CGFloat contentHeight = scrollView.contentSize.height;
        
        if (currentOffSetY < (contentHeight / 8.0)) {
            scrollView.contentOffset = CGPointMake(currentOffsetX,(currentOffSetY + (contentHeight/2)));
        }
        if (currentOffSetY > ((contentHeight * 6)/ 8.0)) {
            scrollView.contentOffset = CGPointMake(currentOffsetX,(currentOffSetY - (contentHeight/2)));
        }
        
        if(scrollView.isDecelerating){
            //[self centerTableWithScrollView: scrollView ];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    NSLog(@"scrollViewWillEndDragging");
    if (scrollView == self.themesView) {
        [self centerTableWithScrollView: scrollView updateData:false ];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // if decelerating, let scrollViewDidEndDecelerating: handle it
    //ecelerate == NO &&
    
    NSLog(@"scrollViewDidEndDragging");
    
    if (decelerate == NO && scrollView == self.themesView) {
        [self centerTableWithScrollView: scrollView updateData : false];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //NSLog(@"scrollViewDidEndDecelerating");
    if (scrollView == self.themesView) {
        [self centerTableWithScrollView: scrollView updateData : true];
    }
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndScrollingAnimation");
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //[self centerTableWithScrollView: scrollView updateData : true];
    
    
    for (UIThemeView *cell in self.themesView.visibleCells) {
        CGRect cellRect = [scrollView convertRect:cell.frame toView:scrollView.superview];
        
        if (CGRectContainsRect(scrollView.frame, cellRect)){
            
            NSLog(@"fully %@", cell.themeLabel.text);
            [self updateThemeDataWithCell:cell];
        }else{
            //NSLog(@"not fully %@", cell.themeLabel.text);
        }
    }
}

- (void)centerTableWithScrollView : (UIScrollView *) scrollView updateData:(BOOL)update{
    NSIndexPath *pathForCenterCell = [self.themesView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(self.themesView.bounds), CGRectGetMidY(self.themesView.bounds))];
    
    [self.themesView scrollToRowAtIndexPath:pathForCenterCell atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    
    if(update){
        for (UIThemeView *cell in self.themesView.visibleCells) {
            CGRect cellRect = [scrollView convertRect:cell.frame toView:scrollView.superview];
            
            if (CGRectContainsRect(scrollView.frame, cellRect)){
                
                NSLog(@"fully %@", cell.themeLabel.text);
                [self updateThemeDataWithCell:cell];
            }else{
                //NSLog(@"not fully %@", cell.themeLabel.text);
            }
        }
    }
}

- (void)setSubthemesBackground {
    
    UIImage *baseImage = [UIImage imageNamed:self.currentTheme.coverImage];
    UIImage *blurImage = [baseImage stackBlur:20];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:blurImage];
    [tempImageView setFrame:self.subThemesView.frame];
    self.subThemesView.backgroundView = tempImageView;
}


#pragma mark - TableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView == self.themesView){
        return [self.themesData count] * 10;
        
    }else{
        return [self.currentThemeSubs count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(tableView == self.themesView){
        UIThemeView *cell = (UIThemeView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"UIThemeView" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
        }
        
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        //UISubThemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"UISubThemeViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            
            //cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.view.frame.size.width/2, cell.frame.size.height);
            
            //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            //cell = [nib objectAtIndex:0];
            
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(tableView == self.themesView){
        NSUInteger actualRow = indexPath.row % [self.themesData count];
        ThemeInterest *theme = [self.themesData objectAtIndex:actualRow];
        BOOL hasSubThemeInPreferences = [ThemeInterest themInterestIsOn:theme forSubThemes: [[[UserDataHolder sharedInstance] user] interests]];
        
        UIThemeView *tCell = (UIThemeView *)cell;
        
        [tCell.themeLabel setText:theme.title];
        [tCell.themeLabel setTextColor: [self colorWithHexString: theme.color]];
        [tCell.themeCheck addTarget:self action:@selector(setThemeState:) forControlEvents:UIControlEventValueChanged];
        
        [tCell updateCellWithImage:theme.coverImage];
        tCell.theme = theme;
        [tCell.themeCheck setOn:hasSubThemeInPreferences];
        //[cell.backgroundImage setFrame:cell.frame];
        
    }else{
        SubThemeInterest* sub = [self.currentThemeSubs objectAtIndex:indexPath.row];
        BOOL isInclude = [[[[UserDataHolder sharedInstance] user] interests] containsObject:sub._id];
        
        UISubThemeViewCell *sCell = (UISubThemeViewCell *)cell;
        [sCell setSubTheme:sub];
        [sCell updateThemeColor: [self colorWithHexString: self.currentTheme.color] isIncluded:isInclude] ;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.subThemesView){
        
        UISubThemeViewCell* cell = (UISubThemeViewCell *)[self.subThemesView cellForRowAtIndexPath:indexPath];
        [cell updateStatus];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.themesView){
        float percent20 = tableView.frame.size.height - (tableView.frame.size.height/3);
        return percent20;
    }else{
        return 100;
    }
}


- (void)setThemeState:(id)sender  {
    BOOL state = [sender isOn];
    //[self.themeDescription setHidden:state];
    [UIView animateWithDuration:0.3 animations:^() {
        self.themeDescription.alpha = state ? 0 : 1.0;
    }];
}

- (void) loadThemesFromNetwork {
    [JSONHTTPClient getJSONFromURLWithString:themesUrl completion:^(id json, JSONModelError *jsonError) {
        NSLog(@"%@", json);
        self.themesData = [[NSMutableArray alloc] init];
        
        for (id j in json) {
            
            NSError* err = nil;
            ThemeInterest *theme  =[[ThemeInterest alloc] initWithDictionary:j error:&err];
            
            [self.themesData addObject:theme];
        }
        
        self.currentTheme = [self.themesData objectAtIndex:0];
        self.currentThemeSubs =[self.currentTheme subthemes];
        [self setSubthemesBackground];
        
        [self.subThemesView reloadInputViews];
        [self.themesView reloadInputViews];
        
        [self.subThemesView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.themesView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        BOOL hasSubThemeInPreferences = [ThemeInterest themInterestIsOn:self.currentTheme forSubThemes: [[[UserDataHolder sharedInstance] user] interests]];
        self.themeDescription.text = self.currentTheme.desc;
        self.themeDescription.alpha = hasSubThemeInPreferences ? 0 : 1;
    }];
}



#pragma mark - Utils

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
