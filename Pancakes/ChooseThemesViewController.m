//
//  ChooseThemesViewController.m
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ChooseThemesViewController.h"
#import "UIImage+StackBlur.h"


@interface ChooseThemesViewController ()

@end

@implementation ChooseThemesViewController {
    NSMutableArray* categoriesViews;
    
}

static NSString *CellIdentifier = @"SubThemeViewCell";
static int currentPageNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initDummy Datas
    
    NSString * filePath =[[NSBundle mainBundle] pathForResource:@"MyInterest" ofType:@"json"];
    NSError * error;
    NSString* fileContents =[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];

    if(error)
    {
        NSLog(@"Error reading file: %@",error.localizedDescription);
    }
    
    NSArray *jsonArray = (NSArray *)[NSJSONSerialization
                                  JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding]
                                  options:0 error:NULL];
    
    self.themesData = [[NSMutableArray alloc] init];
    
    for (id json in jsonArray) {
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];

        
        NSError* err = nil;
        ThemeInterest *theme  =[[ThemeInterest alloc] initWithString:jsonString error:&err];
        
        [self.themesData addObject:theme];
    }
    
    self.currentTheme = [self.themesData objectAtIndex:0];
    
    self.currentThemeSubs =[self.currentTheme subThemes];
    
    
    //InitScrollView and TableView
    int screenMidSize = self.view.frame.size.width/2;
    int screenHeight = self.view.frame.size.height;
    
    
    self.themesView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenMidSize, screenHeight)];
    self.subThemesView = [[UITableView alloc] initWithFrame:CGRectMake(screenMidSize, 0, screenMidSize, screenHeight)];
    self.themeDescription = [[UITextView alloc] initWithFrame:CGRectMake(screenMidSize, 0, screenMidSize, screenHeight)];
    
    self.themeDescription.textContainerInset = UIEdgeInsetsMake(30, 30, 30, 30);
    self.themeDescription.font = [UIFont fontWithName:@"Heuristica-Regular" size:15.5];
    self.themeDescription.textColor = [self colorWithHexString:@"322e1d"];
    
    [self.subThemesView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.themeDescription.text = self.currentTheme.desc;
    self.themeDescription.alpha = 0;
    

    [self.subThemesView setDelegate:self];
    [self.themesView setDelegate:self];
    
    [self.subThemesView setDataSource:self];
    [self.themesView setDataSource:self];
    
    
    [self.view addSubview:self.themesView];
    [self.view addSubview:self.subThemesView];
    [self.view addSubview: self.themeDescription];
    
    [self.subThemesView reloadInputViews];
    [self.themesView reloadInputViews];
    
    [self setSubthemesBackground];
    
    //[self.scrollView setDataSource:self];
}


#pragma mark - UIScrollView

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.frame.size.height;
    NSInteger page = currentPageNumber = (scrollView.contentOffset.y + (0.5f * height)) / height;
     //NSLog(@"offset :%f, page : %i, h : %f",scrollView.contentOffset.y, page, scrollView.frame.size.height);
    
    if(scrollView == self.scrollView){
        
        self.currentTheme = [self.themesData objectAtIndex:page];
        self.currentThemeSubs = self.currentTheme.subThemes;
        //[self.currentTheme objectForKey:@"subthemes"];
        self.themeDescription.text = self.currentTheme.description;
        //[self.currentTheme objectForKey:@"description"];
        
        UIThemeView *view = [[scrollView subviews] objectAtIndex:page];
        
        [UIView animateWithDuration:0.3 animations:^() {
            self.themeDescription.alpha =  view.self.themeCheck.isOn ? 0 : 1.0;
            //[self.themeDescription setHidden:view.self.themeCheck.isOn];
            UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.currentTheme.coverImage]];
            [tempImageView setFrame:self.subThemesView.frame];
             
             self.subThemesView.backgroundView = tempImageView;
        }];
    }
}*/



-(void) updateThemeDataWithCell : (UIThemeView *) cell{
    //[self.subThemesView reloadData];
    // The key is repositioning without animation
    
    self.currentTheme = cell.theme;
    self.currentThemeSubs = self.currentTheme.subThemes;
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
    if (scrollView == self.themesView) {
        [self centerTableWithScrollView: scrollView updateData:false ];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // if decelerating, let scrollViewDidEndDecelerating: handle it
    //ecelerate == NO &&
    if (decelerate == NO && scrollView == self.themesView) {
        [self centerTableWithScrollView: scrollView updateData : false];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.themesView) {
        [self centerTableWithScrollView: scrollView updateData : true];
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
        ThemeInterest *theme =[self.themesData objectAtIndex:actualRow];
        
        UIThemeView *tCell = (UIThemeView *)cell;
        
        [tCell.themeLabel setText:theme.title];
        [tCell.themeLabel setTextColor: [self colorWithHexString: theme.color]];
        [tCell.themeCheck addTarget:self action:@selector(setThemeState:) forControlEvents:UIControlEventValueChanged];
        
        [tCell updateCellWithImage:theme.coverImage];
        tCell.theme = theme;
        //[cell.backgroundImage setFrame:cell.frame];
        
    }else{
        
        UISubThemeViewCell *sCell = (UISubThemeViewCell *)cell;
        SubThemeInterest* sub =[self.currentThemeSubs objectAtIndex:indexPath.row];
        [sCell setSubTheme:sub];
        
        [sCell updateThemeColor: [self colorWithHexString: self.currentTheme.color]];
    }
    
   
    //NSLog(text);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*NSString *subeTheme= [self.currentThemeSubs objectAtIndex:indexPath.row];
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Selected Value is %@",subeTheme] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
     
     [alertView show];
     */
    
    if(tableView == self.subThemesView){
        UISubThemeViewCell* cell = (UISubThemeViewCell *)[self.subThemesView cellForRowAtIndexPath:indexPath];
        [cell updateStatus];
    }else{
        /*
         */
        
    }
}


/*
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}*/

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
