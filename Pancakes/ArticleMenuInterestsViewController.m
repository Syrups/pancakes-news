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
#import "PKCacheManager.h"


@interface ArticleMenuInterestsViewController ()

@end

@implementation ArticleMenuInterestsViewController {
    NSMutableArray* userInterests;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchInterests];
    
    userInterests = [PKCacheManager loadInterestsFromCache];
    
    ArticleViewController* articleVc = (ArticleViewController*)self.parentViewController.parentViewController;
    
    self.article = articleVc.displayedArticle;
}

- (void) fetchInterests {
    
    [PKRestClient getAllThemesAndComplete:^(id json, JSONModelError *err) {
        NSLog(@"%@", json);
        
        self.data = [ThemeInterest arrayOfModelsFromDictionaries:json error:&err];
        
        if (err != nil) {
            NSLog(@"%@", err);
        }
        
        self.subthemes = @[].mutableCopy;
        NSMutableArray* alreadyRegistered = @[].mutableCopy;
        
        for (ThemeInterest* theme in self.data) {
            for (SubThemeInterest* subtheme in theme.subthemes) {
                //avoid doublons
                if ([alreadyRegistered indexOfObject:subtheme._id] == NSNotFound) {
                    subtheme.color = theme.color;
                    subtheme.image = theme.coverImage;
                    [self.subthemes addObject:subtheme];
                    [alreadyRegistered addObject:subtheme._id];
                }
            }
        }
        
        NSString* subthemesUrl = [PKRestClient apiUrlWithRoute:[NSString stringWithFormat:@"/articles/%@/subthemes", self.article._id]];
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:subthemesUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSError* err = nil;
            self.article.subthemes = [SubThemeInterest arrayOfModelsFromData:data error:&err].copy;
            
            // Reload table data on main thread to avoid problems
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }] resume];
    }];
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
    
    UIImageView* check = [[UIImageView alloc] initWithFrame:CGRectMake(30.0f, 35.0f, 22.0f, 15.0f)];
    check.image = [UIImage imageNamed:@"check_item"];
    check.tintColor = [UIColor whiteColor];
    check.contentMode = UIViewContentModeScaleAspectFit;
    check.tag = 50;
    check.alpha = 0.0f;
    [cell.contentView addSubview:check];
    
    NSLog(@"%@", wave);
    
    if ([userInterests indexOfObject:interest] != NSNotFound) {
        cell.contentView.backgroundColor = RgbColor(8, 8, 8);
        themeTitle.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SubThemeInterest* interest = [self.subthemes objectAtIndex:indexPath.row];
    
    if (![self isInUserInterests:interest]) { // toggle add
        [userInterests addObject:interest];
        [self toggleAddCell:[self.tableView cellForRowAtIndexPath:indexPath]];
    } else { // toggle remove
        [self toggleRemove:[self.tableView cellForRowAtIndexPath:indexPath]];
    }

    // refresh interests in cache
    [PKCacheManager cacheIntrests:userInterests];
}

- (void)toggleAddCell:(UITableViewCell*)cell {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView* check = (UIImageView*)[cell.contentView viewWithTag:50];
    check.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.contentView.backgroundColor = RgbColor(8, 8, 8);
        UILabel* themeTitle = (UILabel*)[cell.contentView viewWithTag:10];
        themeTitle.textColor = [UIColor whiteColor];
        
        check.alpha = 1;
        check.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

- (void)toggleRemove:(UITableViewCell*)cell {
    UIImageView* check = (UIImageView*)[cell.contentView viewWithTag:50];
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UILabel* themeTitle = (UILabel*)[cell.contentView viewWithTag:10];
        themeTitle.textColor = RgbColor(8, 8, 8);
        
        check.alpha = 0;
        check.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    } completion:nil];
}

- (BOOL)isInUserInterests:(SubThemeInterest*)interest {
    for (ThemeInterest* theme in userInterests) {
        if (![theme respondsToSelector:@selector(subthemes)]) {
            return NO;
        }
        
        for (SubThemeInterest* subtheme in theme.subthemes) {
            if ([interest._id isEqualToString:subtheme._id]) {
                return YES;
            }
        }
    }
    
    return NO;
}


//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    
//    cell.contentView.backgroundColor = [UIColor whiteColor];
//    UILabel* themeTitle = (UILabel*)[cell.contentView viewWithTag:10];
//    themeTitle.textColor = RgbColor(8, 8, 8);
//}

@end
