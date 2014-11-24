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
#import "PKRestClient.h"

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
    
    /*[[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:themesUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError* err = nil;
        self.data = [ThemeInterest arrayOfModelsFromData:data error:&err];
        
        if (err != nil) {
            NSLog(@"%@", err);
        }
        
        self.subthemes = @[].mutableCopy;
        NSMutableArray* alreadyRegistered = @[].mutableCopy;
        
        for (ThemeInterest* theme in self.data) {
            for (SubThemeInterest* subtheme in theme.subthemes) {
                // avoid doublons
                if ([alreadyRegistered indexOfObject:subtheme._id] == NSNotFound) {
                    subtheme.color = theme.color;
                    subtheme.image = theme.coverImage;
                    [self.subthemes addObject:subtheme];
                    [alreadyRegistered addObject:subtheme._id];
                }
            }
        }
        
        NSString* subthemesUrl = [kApiRootUrl stringByAppendingString:[NSString stringWithFormat:@"/articles/%@/subthemes", self.article._id]];
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:subthemesUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSError* err = nil;
            self.article.subthemes = [SubThemeInterest arrayOfModelsFromData:data error:&err].copy;
            
            // Reload table data on main thread to avoid problems
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }] resume];
        
    }] resume];*/
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
    themeTitle.text = interest.title;
    
    UIImageView* themeThumb = (UIImageView*)[cell.contentView viewWithTag:20];
    [themeThumb setFrame:CGRectMake(themeThumb.frame.origin.x, themeThumb.frame.origin.y, cell.frame.size.width/3.5, cell.frame.size.height)];
    themeThumb.image = [UIImage imageNamed:interest.image];
    themeThumb.clipsToBounds = YES;
    
    UIImageView* wave = (UIImageView*)[cell.contentView viewWithTag:30];
    wave.image = [wave.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [wave setTintColor:[Utils colorWithHexString:interest.color]];
    
    NSLog(@"%@", wave);
    
    if ([self.article containsSubtheme:interest]) {
        cell.contentView.backgroundColor = RgbColor(8, 8, 8);
        themeTitle.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

@end
