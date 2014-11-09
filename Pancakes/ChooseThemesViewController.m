//
//  ChooseThemesViewController.m
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ChooseThemesViewController.h"

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
    self.themeDescription.text = self.currentTheme.description;
    
    //InitScrollView and TableView
    int screenMidSize = self.view.frame.size.width/2;
    int screenHeight = self.view.frame.size.height;
   
    self.subThemesView = [[UITableView alloc] initWithFrame:CGRectMake(screenMidSize, 0, screenMidSize, screenHeight)];
    self.themeDescription = [[UITextView alloc] initWithFrame:CGRectMake(screenMidSize, 0, screenMidSize, screenHeight)];
    
    [self setupCollectionView];
    [self.subThemesView setDelegate:self];
    [self.subThemesView setDataSource:self];
    
    
    [self.subThemesView reloadInputViews];
    [self.scrollView reloadInputViews];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.subThemesView];
    [self.view addSubview: self.themeDescription];
}

-(void)setupCollectionView {
    
    //[self setupDataForCollectionView];
    int screenMidSize = self.view.frame.size.width/2;
    //self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenMidSize, self.view.frame.size.height - 100)];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    
    self.scrollView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenMidSize, self.view.frame.size.height ) collectionViewLayout: flowLayout];
    [self.scrollView registerClass:[UIThemeView class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setCollectionViewLayout:flowLayout];
    [self.scrollView setDelegate:self];
    [self.scrollView setDataSource:self];
    
}

-(void)setupDataForCollectionView {
    
    // Grab references to the first and last items
    // They're typed as id so you don't need to worry about what kind
    // of objects the originalArray is holding
    id firstItem = self.themesData[0];
    id lastItem = [self.themesData lastObject];
    
    NSMutableArray *workingArray = [self.themesData mutableCopy];
    
    // Add the copy of the last item to the beginning
    [workingArray insertObject:lastItem atIndex:0];
    
    // Add the copy of the first item to the end
    [workingArray addObject:firstItem];
    
    // Update the collection view's data source property
    self.themesData = [NSMutableArray arrayWithArray:workingArray];
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.frame.size.height;
    NSInteger page = currentPageNumber = (scrollView.contentOffset.y + (0.5f * height)) / height;
    
    /*
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
    }*/
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (UIThemeView *cell in [self.scrollView visibleCells]) {
        NSIndexPath *indexPath = [self.scrollView indexPathForCell:cell];
        NSLog(@"%ld",(long)indexPath.row);
        
        
        //NSLog(@"scrollViewDidEndDecelerating is %i", currentPageNumber);
        
        if(scrollView == self.scrollView ){
            //[self.subThemesView reloadData];
            // The key is repositioning without animation
            
            self.currentTheme = [self.themesData objectAtIndex:indexPath.row];
            self.currentThemeSubs = self.currentTheme.subThemes;
            self.themeDescription.text = self.currentTheme.desc;
            
            UIThemeView *view = [[scrollView subviews] objectAtIndex:indexPath.row];
            
            [UIView animateWithDuration:0.3 animations:^() {
                self.themeDescription.alpha =  view.self.themeCheck.isOn ? 0 : 1.0;
                //[self.themeDescription setHidden:view.self.themeCheck.isOn];
                UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.currentTheme.coverImage]];
                [tempImageView setFrame:self.subThemesView.frame];
                
                self.subThemesView.backgroundView = tempImageView;
            }];
            
            if (scrollView.contentOffset.x == 0) {
                // user is scrolling to the left from image 1 to image 10.
                // reposition offset to show image 10 that is on the right in the scroll view
                //[scrollView scrollRectToVisible:CGRectMake(3520,0,320,480) animated:NO];
            }
            else if (scrollView.contentOffset.x == 3840) {
                // user is scrolling to the right from image 10 to image 1.
                // reposition offset to show image 1 that is on the left in the scroll view
                //[scrollView scrollRectToVisible:CGRectMake(320,0,320,480) animated:NO];
            }
            
            [self.subThemesView  reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}


#pragma mark - CollectionView

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIThemeView *cell = (UIThemeView *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    ThemeInterest *theme =[self.themesData objectAtIndex:indexPath.row];
    //CGFloat xOrigin = i * self.scrollView.frame.size.height ; //+ 40;
    //UIThemeView *view = [self getUIThemeView:xOrigin];
    //CGRect position = CGRectMake(0, xOrigin , self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    //UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(0, xOrigin, self.view.frame.size.width/2, self.view.frame.size.height)];
    
    //cell.backgroundColor = [UIColor colorWithRed:0.5/indexPath.row green:0.5 blue:0.5 alpha:1]

    [cell.themeLabel setText:theme.title];
    [cell.themeLabel setTextColor: [self colorWithHexString: theme.color]];
    [cell.themeCheck addTarget:self action:@selector(setThemeState:) forControlEvents:UIControlEventValueChanged];
    
    [cell updateCellWithImage:theme.coverImage];
    //[cell.backgroundImage setFrame:cell.frame];
    
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //float percent20 = (self.scrollView.frame.size.height/5);
    return CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.themesData count];
}


#pragma mark - TableView

//Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.currentThemeSubs count];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UISubThemeViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SubThemeInterest* sub =[self.currentThemeSubs objectAtIndex:indexPath.row];
    NSString *text = sub.title;
    [cell.title setText:text];
    
    //NSLog(text);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*NSString *subeTheme= [self.currentThemeSubs objectAtIndex:indexPath.row];
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Selected Value is %@",subeTheme] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
     
     [alertView show];
     */
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UISubThemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
