//
//  ChooseThemesViewController.m
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ChooseThemesViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+StackBlur.h"
#import "Utils.h"
#import "Configuration.h"
#import "Models.h"
#import "Services.h"


@interface ChooseThemesViewController ()

@end

@implementation ChooseThemesViewController {
    NSMutableArray* categoriesViews;
}


NSString * const CellIdentifier = @"SubThemeViewCell";

int screenMidSize;
int screenHeight;
float percent20;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //InitScrollView and TableView
    screenMidSize = self.view.frame.size.width/2;
    screenHeight = self.view.frame.size.height;
    
    
    self.themesView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, screenMidSize, screenHeight - kMenuBarHeigth)];
    self.subThemesView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, screenMidSize, screenHeight)];
    self.themeDescription = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, screenMidSize, screenHeight)];
    
    percent20 = self.themesView.frame.size.height - (self.themesView.frame.size.height/3);
    
    self.themesView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.themeDescription.textContainerInset = UIEdgeInsetsMake(30, 30, 30, 30);
    self.themeDescription.font = [UIFont fontWithName:@"Heuristica-Regular" size:15.5];
    self.themeDescription.textColor = [Utils colorWithHexString:@"322e1d"];
    self.themeDescription.selectable = NO;
    
    [self.subThemesView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //self.themesView.pagingEnabled = YES;
    [self.subThemesView setDelegate:self];
    [self.themesView setDelegate:self];
    
    [self.subThemesView setDataSource:self];
    [self.themesView setDataSource:self];
    
    
    [self.view addSubview:self.themesView];
    [self.view addSubview:self.subThemesView];
    [self.view addSubview: self.themeDescription];
    [self.view addSubview: self.topBlurView];
    
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
   
    [self loadThemesFromNetwork];
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.subThemesView.frame = CGRectMake(screenMidSize, 0, screenMidSize, screenHeight);
        self.themeDescription.frame = CGRectMake(screenMidSize, 0, screenMidSize, screenHeight);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4f  delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^() {
            self.themesView.frame = CGRectMake(0, kMenuBarHeigth, screenMidSize, screenHeight - kMenuBarHeigth);
            
        } completion:nil];
    }];
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    
    
    self.themesView.frame = CGRectMake(0, self.view.frame.size.height, screenMidSize, screenHeight - kMenuBarHeigth);
    self.subThemesView.frame = CGRectMake(self.view.frame.size.width, 0, screenMidSize, screenHeight);
    self.themeDescription.frame = CGRectMake(self.view.frame.size.width, 0, screenMidSize, screenHeight);
}

#pragma mark - UIScrollView


-(void) updateThemeDataWithCell : (UIThemeView *) cell{
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
            [self centerTable];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    if (scrollView == self.themesView) {
        [self centerTable];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.themesView) {
        [self centerTable];
    }
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
   
    //TODO : reset LOOP
    
    for (UIThemeView *cell in self.themesView.visibleCells) {
   
        //UIThemeView *cell = (UIThemeView *)[self.themesView cellForRowAtIndexPath:pathForCenterCell];
        
        CGRect cellRect = [scrollView convertRect:cell.frame toView:scrollView.superview];
        
        if (CGRectContainsRect(scrollView.frame, cellRect)){
            
            [self updateThemeDataWithCell:cell];
            [cell updateAsFullyVisible:YES];
        }else{
            [cell updateAsFullyVisible:NO];
        }
    }
  
    //NSUInteger actualIndex = pathForCenterCell.row % [self.themesData count];
    //ThemeInterest *i = cell.theme;
    //NSLog(@"scrollViewDidEndScrollingAnimation %i, %@ ", actualIndex, i.title);
}

- (NSIndexPath *)centerTable {
    NSIndexPath *pathForCenterCell = [self.themesView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(self.themesView.bounds), CGRectGetMidY(self.themesView.bounds))];
    
    [self.themesView scrollToRowAtIndexPath:pathForCenterCell atScrollPosition:UITableViewScrollPositionTop animated:YES];

    return pathForCenterCell;
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
        
        return [self.themesData count] * 2;
        
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
        [tCell.themeLabel setTextColor: [Utils colorWithHexString: theme.color]];
        [tCell.themeCheck addTarget:self action:@selector(setThemeState:) forControlEvents:UIControlEventValueChanged];
        
        tCell.theme = theme;
        [tCell.themeCheck setOn:hasSubThemeInPreferences];
        
         [tCell updateCellWithImage];
        //[cell.backgroundImage setFrame:cell.frame];
        
    }else{
        SubThemeInterest* sub = [self.currentThemeSubs objectAtIndex:indexPath.row];
        BOOL isInclude = [[[[UserDataHolder sharedInstance] user] interests] containsObject:sub._id];
        
        UISubThemeViewCell *sCell = (UISubThemeViewCell *)cell;
        NSString *url = [PKRestClient mediaUrl:sub.image withRoute:@"subthemes"];
        //NSLog(@"url : %@", url);
        [sCell.picture sd_setImageWithURL:[NSURL URLWithString:url]];
        [sCell setSubTheme:sub];
        [sCell updateThemeColor: [Utils colorWithHexString: self.currentTheme.color] isIncluded:isInclude] ;
        
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
    
    
    //Load from cache
    self.themesData = [PKCacheManager loadInterestsFromCache]; // [[NSMutableArray alloc] init];
    
    if(self.themesData.count > 0){
        [self initThemesForBegin];
    }
    
    
    //Try Loading from network then
    
    [PKRestClient getAllThemesAndComplete:^(id json, JSONModelError *err) {
        if (json == nil) {
            return;
        }
        
        NSLog(@"in network");
        
        self.themesData = [ThemeInterest arrayOfModelsFromDictionaries:json];
        
        [self initThemesForBegin];
        
        //Cache interests
        [PKCacheManager cacheIntrests:self.themesData];
    }];
}

- (void) initThemesForBegin {
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
}

@end
