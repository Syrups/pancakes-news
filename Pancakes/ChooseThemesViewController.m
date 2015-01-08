//
//  ChooseThemesViewController.m
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ChooseThemesViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utils.h"
#import "Configuration.h"
#import "Models.h"
#import "Services.h"
#import "PKSyrupArrow.h"


@interface ChooseThemesViewController ()

@end

@implementation ChooseThemesViewController {
    NSMutableArray* categoriesViews;
}


NSString * const CellIdentifier = @"SubThemeViewCell";

int screenMidSize;
int screenHeight;
float themeCellHeight;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //InitScrollView and TableView
    screenMidSize = self.view.frame.size.width/2;
    screenHeight = self.view.frame.size.height;
    
    
    
    
    self.themesView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, screenMidSize, screenHeight - kMenuBarHeigth)];
    self.subThemesView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, screenMidSize, screenHeight)];
    self.themeDescription = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, screenMidSize, screenHeight)];
    
    themeCellHeight = self.themesView.frame.size.height / 1.3f;
    
    
    //Styles
    
    //themesView -> Performance issues
    
     self.themesView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    
    self.themeDescription.textContainerInset = UIEdgeInsetsMake(30, 30, 30, 30);
    self.themeDescription.font = [UIFont fontWithName:@"Heuristica-Regular" size:15.5];
    self.themeDescription.textColor = [Utils colorWithHexString:@"322e1d"];
    self.themeDescription.selectable = NO;
    
    //subThemesView
    [self.subThemesView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //self.themesView.pagingEnabled = YES;
    [self.subThemesView setDelegate:self];
    [self.themesView setDelegate:self];
    
    [self.subThemesView setDataSource:self];
    [self.themesView setDataSource:self];
    
    [self.view addSubview:self.subThemesView];
    [self.view addSubview: self.themeDescription];
    //Shadow first
    
    [self.view addSubview:self.themesView];
    //[self addDropShadowToView:self.themesView];
    [Utils addDropShadowToView:self.themesView];
    
    PKSyrupArrow* arr = [[PKSyrupArrow alloc] initWithFrame:CGRectMake(screenMidSize/2 - 7, screenHeight-50, 15, 8)];
    [self.view addSubview:arr];
    
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
   
    [self loadThemesFromNetwork];
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.subThemesView.frame = CGRectMake(screenMidSize, 0, screenMidSize, screenHeight);
        self.themeDescription.frame = CGRectMake(screenMidSize, 0, screenMidSize, screenHeight);
        
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.4f  delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^() {
            self.themesView.frame = CGRectMake(0, kMenuBarHeigth, screenMidSize, screenHeight - kMenuBarHeigth);
            
            [self.view layoutIfNeeded];
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
        self.themeDescription.alpha =  cell.self.themeCheck.isOn ? 1.0 : 0;
        [self setSubthemesBackground];
    }];
    
    [self.subThemesView  reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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
        //[self centerTable];
    }
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
   
    //TODO : reset LOOP
    
    for (UIThemeView *cell in self.themesView.visibleCells) {
        CGRect cellRect = [scrollView convertRect:cell.frame toView:scrollView.superview];
        
        float cellY = roundf(cellRect.origin.y);
        if (kMenuBarHeigth == cellY){
            
            [self updateThemeDataWithCell:cell];
            [cell updateAsFullyVisible:YES];
            //NSLog(@"updateAsFullyVisible : YES : %@ : %f", cell.themeLabel.text, cellY);
        }else{
            [cell updateAsFullyVisible:NO];
            //NSLog(@"updateAsFullyVisible : NO : %@ : %f", cell.themeLabel.text, cellY);
        }
    }
    
    //NSLog(@"___________________________");
  
    //NSUInteger actualIndex = pathForCenterCell.row % [self.themesData count];
    //ThemeInterest *i = cell.theme;
    //NSLog(@"scrollViewDidEndScrollingAnimation %i, %@ ", actualIndex, i.title);
}

- (NSIndexPath *)centerTable {
    NSIndexPath *pathForCenterCell = [self.themesView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(self.themesView.bounds), CGRectGetMidY(self.themesView.bounds))];
    
    [self.themesView scrollToRowAtIndexPath:pathForCenterCell atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //NSLog(@"_____GO Center_______");
    return pathForCenterCell;
}


- (void)setSubthemesBackground {
    
//    UIImage *baseImage  = [[UIImage imageNamed:self.currentTheme.coverImage] blurredImageWithRadius:20 iterations:1 tintColor:[UIColor clearColor]];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.currentTheme.coverImage]];
    [tempImageView setFrame:self.subThemesView.frame];
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    
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
        
        UIColor *themeColor = [Utils colorWithHexString: theme.color];
        [tCell.themeLabel setText:theme.title];
        [tCell.themeLabel setTextColor: themeColor];
        
        
        tCell.themeCheck.innerColor = [UIColor colorWithWhite:1 alpha:0];
        tCell.themeCheck.innerImageColor = themeColor;
        tCell.themeCheck.borderColor = themeColor;
        [tCell.themeCheck addTarget:self action:@selector(setThemeState:) forControlEvents:UIControlEventValueChanged];
        
        tCell.theme = theme;
        [tCell.themeCheck setIsOn:!hasSubThemeInPreferences];
        
        [tCell updateCellWithImage];
        //[cell.backgroundImage setFrame:cell.frame];
        
    }else{
        SubThemeInterest* sub = [self.currentThemeSubs objectAtIndex:indexPath.row];
        BOOL isInclude = [[[[UserDataHolder sharedInstance] user] interests] containsObject:sub._id];
        
        UISubThemeViewCell *sCell = (UISubThemeViewCell *)cell;
        NSString *url = [PKRestClient mediaUrl:sub.image withRoute:@"subthemes"];
        
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
        
        return themeCellHeight;
    }else{
        return 90;
    }
}


- (void)setThemeState:(id)sender  {
    BOOL state = [sender isOn];
    //[self.themeDescription setHidden:state];
    [UIView animateWithDuration:0.3 animations:^() {
        self.themeDescription.alpha = state ? 1.0 : 0;
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
        
        NSLog(@"in network : %@", json);
        
        self.themesData = [ThemeInterest arrayOfModelsFromDictionaries:json];
        
        [self initThemesForBegin];
        
        //Cache interests
        [PKCacheManager cacheIntrests:json];
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
