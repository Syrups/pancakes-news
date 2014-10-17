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

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //initDummy Datas
    
    self.themesData = @[
                        @{@"name":@"All",
                          @"subthemes":@[@"Lol",@"Li",@"LA"]
                          },
                        @{@"name":@"Diseases",
                          @"subthemes":@[@"EBOLA",@"VIH",@"HAN1"]
                          },
                        @{@"name":@"Health",
                          @"subthemes":@[@"One",@"Two",@"Three"]
                          },
                        @{@"name":@"Economics",
                          @"subthemes":@[@"WallStreet",@"Oil",@"Exchanges"]
                          },
                        ];
    
    self.currentTheme = [self.themesData objectAtIndex:0];
    self.currentThemeSubs = [self.currentTheme objectForKey:@"subthemes"];
    
    //InitScrollView and TableView
    int screenMidSize = self.view.frame.size.width/2;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenMidSize, self.view.frame.size.height)];
    self.subThemesView = [[UITableView alloc] initWithFrame:CGRectMake(screenMidSize, 0, screenMidSize, self.view.frame.size.height)];
    
    [self.subThemesView setDelegate:self];
    [self.subThemesView setDataSource:self];
    
    
    [self loadCategoriesScrollView];
}

- (void)loadCategoriesScrollView {
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.subThemesView.delegate = self;
    
    NSInteger numberOfViews = [self.themesData count];
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * self.scrollView.frame.size.height;
        //UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(0, xOrigin, self.view.frame.size.width/2, self.view.frame.size.height)];
        //awesomeView.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
        
        UIThemeView *view = [self getUIThemeView:xOrigin];
        [view.themeLabel setText:[[self.themesData objectAtIndex:i] objectForKey:@"name"]];
        view.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
        [self.scrollView addSubview:view];
        //[categoriesViews addObject:view];
    }
    
    self.scrollView.showsVerticalScrollIndicator = YES;
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width / 2, self.view.frame.size.height * numberOfViews);

    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.subThemesView];
}

- (UIThemeView*) getUIThemeView: (CGFloat) xOrigin{
    CGRect position = CGRectMake(0, xOrigin, self.view.frame.size.width/2, self.view.frame.size.height);
    UIThemeView *themeView = [[[NSBundle mainBundle] loadNibNamed:@"UIThemeView" owner:self options:nil] objectAtIndex:0];
    [themeView setFrame:position];
    return themeView;
}

- (UIView*) getCurrentDisplayedView {
    CGFloat width = self.scrollView.frame.size.height;
    NSUInteger page = (self.scrollView.contentOffset.y + (0.5f * width)) / width;
    
    return [categoriesViews objectAtIndex:page];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.scrollView.frame.size.height;
    NSUInteger page = (self.scrollView.contentOffset.y + (0.5f * width)) / width;
    
    self.currentTheme = [self.themesData objectAtIndex:page];
    self.currentThemeSubs = [self.currentTheme objectForKey:@"subthemes"];
    
    [self.subThemesView reloadData];
    
}


//Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.currentThemeSubs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.currentThemeSubs objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
   
    NSString *subeTheme= [self.currentThemeSubs objectAtIndex:indexPath.row];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Selected Value is %@",subeTheme] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
    
}
@end
