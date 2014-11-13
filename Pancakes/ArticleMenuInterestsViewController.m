//
//  ArticleMenuInterestsViewController.m
//  Pancakes
//
//  Created by Leo on 10/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ArticleMenuInterestsViewController.h"
#import "ArticleViewController.h"
#import "Configuration.h"
#import <JSONModel/JSONHTTPClient.h>
#import "ThemeInterest.h"
#import "SubThemeInterest.h"
#import "Utils.h"

@interface ArticleMenuInterestsViewController ()

@end

@implementation ArticleMenuInterestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchInterests];
    
    ArticleViewController* articleVc = (ArticleViewController*)self.parentViewController.parentViewController;
    
    self.article = articleVc.displayedArticle;
}

- (void) fetchInterests {
    NSString* themesUrl = [kApiRootUrl stringByAppendingString:@"/themes"];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:themesUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError* err = nil;
        self.data = [ThemeInterest arrayOfModelsFromData:data error:&err];
        
        if (err != nil) {
            NSLog(@"%@", err);
        }
        
        self.subthemes = @[].mutableCopy;
        
        for (ThemeInterest* theme in self.data) {
            for (SubThemeInterest* subtheme in theme.subthemes) {
                subtheme.color = theme.color;
                subtheme.image = theme.coverImage;
                [self.subthemes addObject:subtheme];
            }
        }
        
        // Reload table data on main thread to avoid problems
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }] resume];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subthemes.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height/4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InterestCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InterestCell"];
    }
    
    SubThemeInterest* interest = [self.subthemes objectAtIndex:indexPath.row];
    
    UILabel* themeTitle = (UILabel*)[cell.contentView viewWithTag:10];
    themeTitle.textColor = [Utils colorWithHexString:interest.color];
    themeTitle.text = interest.title;
    
    UIImageView* themeThumb = (UIImageView*)[cell.contentView viewWithTag:20];
    [themeThumb setFrame:CGRectMake(themeThumb.frame.origin.x, themeThumb.frame.origin.y, cell.frame.size.width/3.5, cell.frame.size.height)];
    themeThumb.image = [UIImage imageNamed:interest.image];
    themeThumb.clipsToBounds = YES;
    
    if ([self.article containsSubtheme:interest]) {
        NSLog(@"FOUND");
        cell.contentView.backgroundColor = RgbColor(8, 8, 8);
        themeTitle.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

@end
